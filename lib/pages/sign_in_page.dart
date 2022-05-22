import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:submon/browser.dart';
import 'package:submon/components/hidable_progress_indicator.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/twitter_sign_in.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../apple_sign_in.dart';
import '../db/firestore_provider.dart';
import '../method_channel/messaging.dart';
import '../utils/dynamic_links.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, dynamic arguments})
      : initialCred = arguments?["initialCred"],
        reAuth = arguments?["reAuth"] ?? false,
        upgrade = arguments?["upgrade"] ?? false,
        // forMigration = arguments?["forMigration"] ?? false,
        super(key: key);

  final UserCredential? initialCred;
  final bool reAuth;
  final bool upgrade;

  // final bool forMigration;

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var loading = false;

  @override
  void initState() {
    super.initState();
    if (widget.reAuth) {
      reAuth();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ログイン / 新規登録'),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              HidableLinearProgressIndicator(show: loading),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text("続行するには、以下の利用規約・プライバシーポリシーに同意する必要があります。",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .bodyText1!
                                .color)),
                    Row(
                      children: [
                        TextButton(
                          onPressed: Browser.openTermsOfUse,
                          child: Text("利用規約",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          onPressed: Browser.openPrivacyPolicy,
                          child: Text("プライバシーポリシー",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.mail, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange.shade800,
                        ),
                        label: const Text("メールアドレスでログイン",
                            style: TextStyle(color: Colors.white)),
                        onPressed: (!loading && !widget.reAuth)
                            ? () {
                                wrapSignIn(() async =>
                                    await Navigator.pushNamed<dynamic>(
                                        context, "/signIn/email"));
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (Platform.isIOS || Platform.isMacOS)
                      Column(
                        children: [
                          _buildAppleSignInButton(),
                          const SizedBox(height: 16),
                          _buildGoogleSignInButton(),
                          const SizedBox(height: 16),
                          _buildTwitterSignInButton(),
                        ],
                      )
                    else
                      Column(
                        children: [
                          _buildGoogleSignInButton(),
                          const SizedBox(height: 16),
                          _buildTwitterSignInButton(),
                          const SizedBox(height: 16),
                          _buildAppleSignInButton(),
                        ],
                      ),
                    const SizedBox(height: 24),
                    if (Platform.isIOS)
                      Text(
                          "「Googleでログイン」もしくは「Twitterでログイン」をタップすると、「あなたに関する情報を共有することを許可します」"
                          "という内容のダイアログが表示されます。\nここでいう「あなたに関する情報」はログインに使用する情報のみですので、"
                          "ログインする場合は「続ける」をタップしてください。",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1!
                                  .color)),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildAppleSignInButton() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          "assets/vector/apple.svg",
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(primary: Colors.blueGrey),
        label: const Text("Appleでサインイン", style: TextStyle(color: Colors.white)),
        onPressed: !loading && !widget.reAuth
            ? () {
                wrapSignIn(signInWithApple);
              }
            : null,
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          "assets/vector/google.svg",
        ),
        style: ElevatedButton.styleFrom(primary: Colors.white),
        label:
            const Text("Googleでサインイン", style: TextStyle(color: Colors.black)),
        onPressed: !loading && !widget.reAuth
            ? () {
                wrapSignIn(signInWithGoogle);
              }
            : null,
      ),
    );
  }

  Widget _buildTwitterSignInButton() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton.icon(
        icon: SvgPicture.asset(
          "assets/vector/twitter.svg",
          color: Colors.white,
        ),
        style: ElevatedButton.styleFrom(primary: const Color(0xff1da1f2)),
        label: Text("Twitterでサインイン",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Colors.white)),
        onPressed: !loading && !widget.reAuth
            ? () async {
                var result = await signInWithTwitter();

                if (result != null) {
                  await completeLogin(result, context);
                  Navigator.pop(context, true);
                }
              }
            : null,
      ),
    );
  }

  void wrapSignIn(Future<UserCredential?> Function() signInFunc) async {
    setState(() {
      loading = true;
    });

    var result = await signInFunc();

    if (result != null) {
      await completeLogin(result, context);
      Navigator.pop(context, true);
    }

    setState(() {
      loading = false;
    });
  }

  Future<UserCredential?> signInWithGoogle() async {
    var googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final cred = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      if (widget.reAuth) {
        return await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(cred);
      } else if (widget.upgrade) {
        return await FirebaseAuth.instance.currentUser!
            .linkWithCredential(cred);
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e, stack) {
      handleCredentialError(e, stack);
    } on PlatformException catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showSnackBar(context, "エラーが発生しました。(${e.message})");
    }
    return null;
  }

  // sign in with apple

  Future<UserCredential?> signInWithApple() async {
    final rawNonce = generateNonce();
    final state = generateNonce();
    final nonce = AppleSignIn.sha256ofString(rawNonce);

    try {
      AuthorizationCredentialAppleID appleCredential;
      if (Platform.isIOS || Platform.isMacOS) {
        appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
            nonce: nonce,
            state: state,
            webAuthenticationOptions: WebAuthenticationOptions(
                clientId: "net.chikach.submon.asi",
                redirectUri: Uri.parse(
                    "https://asia-northeast1-submon-mgr.cloudfunctions.net/appleSignInRedirector")));
      } else {
        setState(() {
          loading = false;
        });
        appleCredential =
            (await AppleSignIn().signIn(state: state, nonce: nonce))!;
      }

      if (state != appleCredential.state) {
        showSnackBar(context, "State mismatch.");
        return null;
      }

      setState(() {
        loading = true;
      });

      final cred = OAuthProvider("apple.com").credential(
          accessToken: appleCredential.authorizationCode,
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce);

      if (widget.reAuth) {
        return await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(cred);
      } else if (widget.upgrade) {
        return await FirebaseAuth.instance.currentUser!
            .linkWithCredential(cred);
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e, stack) {
      handleCredentialError(e, stack);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showSnackBar(context, "エラーが発生しました");
    }
    return null;
  }

  // sign in with twitter
  Future<UserCredential?> signInWithTwitter() async {
    var authResult = await TwitterSignIn.getInstance(context).signIn();

    if (authResult?.errorMessage != null) {
      showSnackBar(context, authResult!.errorMessage!);
      return null;
    }

    if (authResult == null) {
      return null;
    }

    setState(() {
      loading = true;
    });

    final cred = TwitterAuthProvider.credential(
      accessToken: authResult.accessToken!,
      secret: authResult.accessTokenSecret!,
    );

    try {
      if (widget.reAuth) {
        return await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(cred);
      } else if (widget.upgrade) {
        return await FirebaseAuth.instance.currentUser!
            .linkWithCredential(cred);
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e, stack) {
      handleCredentialError(e, stack);
      setState(() {
        loading = false;
      });
      return null;
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  void handleCredentialError(FirebaseAuthException e, StackTrace stack) {
    switch (e.code) {
      case "account-exists-with-different-credential":
        showSnackBar(context, "このアカウントに紐付けられたメールアドレスのユーザーが既に存在します。");
        break;
      case "invalid-credential":
        print(e.message);
        showSnackBar(context, "エラー: 資格情報が無効です");
        break;
      default:
        handleAuthError(e, stack, context);
    }
  }

  void reAuth() {
    Future(() async {
      var auth = FirebaseAuth.instance;

      var currentUser = auth.currentUser!;
      var providerId = currentUser.providerData.first.providerId;

      if (providerId == EmailAuthProvider.PROVIDER_ID) {
        showLoadingModal(context);

        var methods = await auth.fetchSignInMethodsForEmail(currentUser.email!);

        Navigator.pop(context); // Close Loading modal

        if (methods.first == EmailAuthProvider.EMAIL_PASSWORD_SIGN_IN_METHOD) {
          var result = await Navigator.pushNamed(context, "/signIn/email",
              arguments: {'reAuth': true});
          Navigator.pop(context, result != null);
        } else if (methods.first ==
            EmailAuthProvider.EMAIL_LINK_SIGN_IN_METHOD) {
          showSimpleDialog(
            context,
            "追加認証",
            "セキュリティのため、再度ログインする必要があります。送信されたメールにあるURLをタップし、ログインしてください。\n\n"
                "その後、再度メールアドレス変更をお試しください。",
            onOKPressed: () async {
              showLoadingModal(context);
              try {
                await auth.sendSignInLinkToEmail(
                    email: currentUser.email!,
                    actionCodeSettings:
                        actionCodeSettings(getAppDomain("", withScheme: true)));
                showSnackBar(context, "送信しました");
              } catch (e, stack) {
                showSnackBar(context, "エラーが発生しました");
                recordErrorToCrashlytics(e, stack);
              }
              Navigator.pop(context); // Close Loading modal
              Navigator.pop(context); // Close sign in page
            },
            onCancelPressed: () {
              Navigator.pop(context); // Close sign in page
            },
            showCancel: true,
          );
        }
      } else {
        try {
          UserCredential? result;
          if (providerId == GoogleAuthProvider.PROVIDER_ID) {
            result = await signInWithGoogle();
          } else if (providerId == TwitterAuthProvider.PROVIDER_ID) {
            result = await signInWithTwitter();
          } else if (providerId == "apple.com") {
            result = await signInWithApple();
          }

          Navigator.pop(context, result != null && result.user != null);
        } on FirebaseAuthException catch (e, stack) {
          switch (e.code) {
            case "user-mismatch":
              showSnackBar(context, "ユーザーがログインされているものと一致しません");
              break;
            default:
              handleAuthError(e, stack, context);
          }
          Navigator.pop(context);
        }
      }
    });
  }
}

Future<void> completeLogin(UserCredential result, BuildContext context) async {
  try {
    try {
      var doc =
          FirebaseFirestore.instance.collection("users").doc(result.user!.uid);
      await doc.get();
      FirebaseAnalytics.instance.logLogin(
          loginMethod: result.additionalUserInfo?.providerId ?? "unknown");
      showSnackBar(context, "ログインしました");
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        showSnackBar(context, "アカウントを作成しています。しばらくお待ち下さい・・・",
            duration: const Duration(seconds: 10));
        await FirestoreProvider.initializeUser();
        showSnackBar(context, "アカウントを作成しました");
        FirebaseAnalytics.instance.logSignUp(
            signUpMethod: result.additionalUserInfo?.providerId ?? "unknown");
      } else {
        rethrow;
      }
    }
    // save messaging token
    MessagingPlugin.getToken().then((token) {
      FirestoreProvider.saveNotificationToken(token);
    });
    MainMethodPlugin.updateWidgets();
    SharedPrefs.use((prefs) {
      prefs.firestoreLastChanged = null;
    });
  } catch (e) {
    FirebaseCrashlytics.instance.recordError(e, (e as dynamic).stackTrace);
    showSnackBar(context, "エラーが発生しました");
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
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

import '../db/firestore_provider.dart';
import '../method_channel/messaging.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key, dynamic arguments})
      : initialCred = arguments?["initialCred"],
        reAuth = arguments?["reAuth"] ?? false,
        // forMigration = arguments?["forMigration"] ?? false,
        super(key: key);

  final UserCredential? initialCred;
  final bool reAuth;

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
    // if (widget.forMigration) {
    //   Firebase.initializeApp(
    //       name: "old",
    //       options: const FirebaseOptions(
    //         apiKey: "***REMOVED***",
    //         appId: "1:218237880785:android:4ec8e02f50fe7dcd",
    //         messagingSenderId: "218237880785",
    //         projectId: "mydatauploader",
    //       )
    //   );
    // }
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
                          child: Text("利用規約",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          onPressed: openTermsOfUse,
                        ),
                        const SizedBox(width: 16),
                        TextButton(
                          child: Text("プライバシーポリシー",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary)),
                          onPressed: openPrivacyPolicy,
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
                      SizedBox(
                        width: 250,
                        height: 50,
                        child: ElevatedButton.icon(
                          icon: SvgPicture.asset(
                            "assets/vector/apple.svg",
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey),
                          label: const Text("Appleでログイン",
                              style: TextStyle(color: Colors.white)),
                          onPressed: !loading && !widget.reAuth
                              ? () {
                            showPlatformDialog(
                                context: context,
                                builder: (context) {
                                  return PlatformAlertDialog(
                                    title: const Text("注意"),
                                    content: const Text(
                                        "現在、Android版ではAppleログインをご利用いただけません。"
                                            "そのため、Android端末にデータ移行することができません。続行しますか？"),
                                    actions: [
                                      PlatformTextButton(
                                          child: const Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      PlatformTextButton(
                                          child: const Text("OK"),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                                  wrapSignIn(signInWithApple);
                                                }),
                                    ],
                                  );
                                });
                          }
                              : null,
                        ),
                      ),
                    if (Platform.isIOS || Platform.isMacOS)
                      const SizedBox(height: 16),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          "assets/vector/google.svg",
                        ),
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        label: const Text("Googleでログイン",
                            style: TextStyle(color: Colors.black)),
                        onPressed: !loading && !widget.reAuth
                            ? () {
                                wrapSignIn(signInWithGoogle);
                              }
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: SvgPicture.asset(
                          "assets/vector/twitter.svg",
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: const Color(0xff1da1f2)),
                        label: Text("Twitterでログイン",
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
                    ),
                    const SizedBox(height: 24),
                    if (Platform.isIOS)
                      Text(
                          "「Googleでログイン」もしくは「Twitterでログイン」をタップすると、「あなたに関する情報を共有することを許可します」"
                              "という内容のダイアログが表示されます。\nここでいう「情報」はログインのみに使用する情報ですので、"
                              "ログインする場合は「続ける」をタップしてください。",
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1!
                                  .color)),
                    if (Platform.isAndroid)
                      const Text(
                          "現在、ライブラリの不具合のためAndroidにおけるAppleログインの実装を見送っております。",
                          style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 8),
                    // const Text(
                    //     "現在、ライブラリの不具合のためTwitterログインは利用できません。以前までTwitterログインをご利用になられていた方は恐れ入りますが、しばらくの間は以前のアプリをご利用ください。"),
                  ],
                ),
              ),
            ],
          ),
        ));
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
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e) {
      handleCredentialError(e);
    } on PlatformException catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showSnackBar(context, "エラーが発生しました。(${e.message})");
    }
    return null;
  }

  // sign in with apple

  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential?> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final cred = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      if (widget.reAuth) {
        return await FirebaseAuth.instance.currentUser!
            .reauthenticateWithCredential(cred);
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e) {
      handleCredentialError(e);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      showSnackBar(context, "エラーが発生しました");
    }
    return null;
  }

  // sign in with twitter
  Future<UserCredential?> signInWithTwitter() async {
    var authResult = await TwitterSignIn(
      apiKey: dotenv.env["TWITTER_API_KEY"]!,
      apiSecret: dotenv.env["TWITTER_API_SECRET"]!,
      redirectUri: "submon://",
      context: context,
    ).signIn();

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
      } else {
        return await signInWithCredential(cred);
      }
    } on FirebaseAuthException catch (e) {
      handleCredentialError(e);
      setState(() {
        loading = true;
      });
      return null;
    }
  }

  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    // if (widget.forMigration) {
    //   return FirebaseAuth.instanceFor(app: Firebase.app("old")).signInWithCredential(credential);
    // } else {
    return FirebaseAuth.instance.signInWithCredential(credential);
    // }
  }

  void handleCredentialError(FirebaseAuthException e) {
    switch (e.code) {
      case "account-exists-with-different-credential":
        showSnackBar(context, "このアカウントに紐付けられたメールアドレスのユーザーが既に存在します。");
        break;
      case "invalid-credential":
        print(e.message);
        showSnackBar(context, "エラー: 資格情報が無効です");
        break;
      default:
        handleAuthError(e, context);
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
                    actionCodeSettings: actionCodeSettings());
                showSnackBar(context, "送信しました");
              } catch (e) {
                showSnackBar(context, "エラーが発生しました");
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
        } on FirebaseAuthException catch (e) {
          switch (e.code) {
            case "user-mismatch":
              showSnackBar(context, "ユーザーがログインされているものと一致しません");
              break;
            default:
              handleAuthError(e, context);
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
      showSnackBar(context, "ログインしました");
    } on FirebaseException catch (e) {
      if (e.code == "permission-denied") {
        await FirestoreProvider.initializeUser();
        showSnackBar(context, "アカウントを作成しました");
      } else {
        rethrow;
      }
    }
    // save messaging token
    MessagingPlugin.getToken().then((token) {
      FirestoreProvider.saveNotificationToken(token);
    });
    updateWidgets();
    SharedPrefs.use((prefs) {
      prefs.firestoreLastChanged = null;
    });
  } catch (e) {
    FirebaseCrashlytics.instance.recordError(e, (e as dynamic).stackTrace);
    showSnackBar(context, "エラーが発生しました");
  }
}

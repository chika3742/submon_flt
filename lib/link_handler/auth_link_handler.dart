import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:url_launcher/url_launcher.dart";

import "../auth/sign_in_handler.dart";
import "../core/pref_key.dart";
import "../pages/settings/account_edit_page.dart";
import "../providers/core_providers.dart";
import "../utils/ui.dart";
import "../utils/utils.dart";

void handleAuthLink(BuildContext context, WidgetRef ref, Uri url) {
  switch (url.queryParameters["mode"]) {
    case "signIn":
      if (!FirebaseAuth.instance.isSignInWithEmailLink(url.toString())) {
        showSnackBar(context, "リンクが正しくありません。");
        return;
      }
      _handleSignIn(context, ref, url);
      break;
    case "verifyAndChangeEmail":
      _handleVerifyAndChangeEmail(context, url);
      break;
    default:
      launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

Future<void> _handleSignIn(
  BuildContext context,
  WidgetRef ref,
  Uri url,
) async {
  final c = url.queryParameters["continueUrl"];
  final continueUri = c != null ? Uri.parse(c) : url;

  if (continueUri.path == "/account/delete") {
    launchUrl(url, mode: LaunchMode.externalApplication);
    return;
  }

  final mode = continueUri.queryParameters["internalMode"];
  final currentUser = ref.read(firebaseUserProvider).value;
  if (mode == SignInMode.normal.name && currentUser != null) {
    showSnackBar(context, "既にログインされています。ログアウトしてからお試しください。");
    return;
  }

  final email = ref.readPref(PrefKey.emailForUrlLogin);
  if (email != null) {
    final handler = SignInHandler(
      SignInMode.values.firstWhere((e) => e.name == mode),
    );
    if (!context.mounted) return;
    showLoadingModal(context);
    try {
      final result = await handler.signInWithLink(
        email: email,
        emailLink: url.toString(),
      );
      await handler.handleSignInResult(result);

      if (mode == SignInMode.reauthenticate.name && context.mounted) {
        Navigator.popAndPushNamed(context, continueUri.path,
            arguments: AccountEditPageArguments(
                continueUri.queryParameters["new_email"]));
      }
    } on FirebaseAuthException catch (e, stack) {
      if (!context.mounted) return;
      if (e.code == "invalid-action-code") {
        showSnackBar(context, "URLの有効期限が切れたか、コードが正しくありません。");
      } else if (e.code == "email-already-in-use") {
        showSnackBar(context, "このメールアドレスは既に使用されています。");
      } else {
        showSnackBar(context, "エラーが発生しました。(${e.code})");
        FirebaseCrashlytics.instance.recordError(e, stack);
      }
      Navigator.of(context, rootNavigator: true).pop();
    } catch (e, stack) {
      if (!context.mounted) return;
      showSnackBar(context, "エラーが発生しました。");
      FirebaseCrashlytics.instance.recordError(e, stack);
      Navigator.of(context, rootNavigator: true).pop();
    }
  } else {
    showSnackBar(context, "ログインするデバイスと同じものでリンクを開いてください。");
  }
}

Future<void> _handleVerifyAndChangeEmail(
  BuildContext context,
  Uri url,
) async {
  final codeInfo = await _checkAuthActionCode(context, url);

  if (codeInfo != null && context.mounted) {
    await FirebaseAuth.instance.signOut();
    backToWelcomePage(context);
    launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

Future<ActionCodeInfo?> _checkAuthActionCode(
  BuildContext context,
  Uri url,
) async {
  final oobCode = url.queryParameters["oobCode"];
  if (oobCode == null) {
    showSnackBar(context, "URLの形式が正しくありません");
    return null;
  }

  showLoadingModal(context);

  try {
    return await FirebaseAuth.instance.checkActionCode(oobCode);
  } on FirebaseAuthException catch (e, stack) {
    if (!context.mounted) return null;
    switch (e.code) {
      case "invalid-action-code":
      case "firebase_auth/invalid-action-code":
        showSnackBar(context, "URLの有効期限が切れたか、コードが正しくありません。");
        break;
      default:
        handleAuthError(e, stack, context);
        break;
    }
  } catch (e, stack) {
    if (!context.mounted) return null;
    showSnackBar(context, "エラーが発生しました。");
    FirebaseCrashlytics.instance.recordError(e, stack);
  } finally {
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
  return null;
}

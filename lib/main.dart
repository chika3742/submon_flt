import "dart:io";
import "dart:ui";

import "package:animations/animations.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:intl/intl.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:shared_preferences/shared_preferences.dart";

import "core/pref_key.dart";
import "events.dart";
import "features/auth/presentation/auth_action_notifier.dart";
import "features/auth/presentation/auth_messages.dart";
import "features/auth/presentation/email_link_auth_notifier.dart";
import "features/google_tasks/models/tasks_operation_exception.dart";
import "features/submission/presentation/submission_save_state_notifier.dart";
import "link_handler/link_handler.dart";
import "pages/done_submissions_page.dart";
import "pages/email_registration_page.dart";
import "pages/email_sign_in_page.dart";
import "pages/focus_timer_page.dart";
import "pages/home_page.dart";
import "pages/settings/account_edit_page.dart";
import "pages/settings/account_link_page.dart";
import "pages/settings/customize.dart";
import "pages/settings/functions.dart";
import "pages/settings/general.dart";
import "pages/settings/google_tasks.dart";
import "pages/settings/timetable.dart";
import "pages/settings_page.dart";
import "pages/sign_in_page.dart";
import "pages/submission_create_page.dart";
import "pages/submission_detail_page.dart";
import "pages/submission_edit_page.dart";
import "pages/timetable_edit_page.dart";
import "pages/timetable_table_view_page.dart";
import "pages/welcome_page.dart";
import "providers/core_providers.dart";
import "providers/link_events_provider.dart";
import "utils/ui.dart";

const screenShotMode = bool.fromEnvironment("SCREENSHOT_MODE");

@Deprecated("Use BuildContext from widget tree instead")
BuildContext? get globalContext => Application.globalKey.currentContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  FlutterError.onError =
      FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  // load .env
  await dotenv.load();

  // Initialize SharedPreferences
  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );

  // initialize Google user (for Tasks API)
  await GoogleSignIn.instance.initialize();

  // initialize AdMob
  await MobileAds.instance.initialize();

  // register font licenses
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(["google_fonts"],
        await rootBundle.loadString("assets/google_fonts/Murecho/OFL.txt"));
    yield LicenseEntryWithLineBreaks(
        ["google_fonts"],
        await rootBundle
            .loadString("assets/google_fonts/B612_Mono/OFL.txt"));
    yield LicenseEntryWithLineBreaks(["google_fonts"],
        await rootBundle.loadString("assets/google_fonts/Play/OFL.txt"));
  });

  Intl.defaultLocale = PlatformDispatcher.instance.locale.toString();

  runApp(
    ProviderScope(
      overrides: [
        sharedPrefsServiceProvider.overrideWithValue(prefs),
      ],
      child: const _EagerInitialization(
        child: Application(),
      ),
    ),
  );
}

/// isarProviderとfirebaseUserProviderをアプリ起動時に初期化し、以降の画面で常に利用可能
/// にするためのWidget
class _EagerInitialization extends ConsumerWidget {
  const _EagerInitialization({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(isarProvider);
    ref.watch(firebaseUserProvider);
    return child;
  }
}

class Application extends ConsumerStatefulWidget {
  const Application({super.key});

  static var globalKey = GlobalKey<NavigatorState>();

  @override
  ConsumerState<Application> createState() => _ApplicationState();
}

class _ApplicationState extends ConsumerState<Application> {
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      ref.updatePref(PrefKey.lastVersionCode, int.parse(info.buildNumber));
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(linkEventsProvider, (_, next) {
      if (next case AsyncData(:final value)) {
        handleLink(globalContext!, ref, value.value, onSwitchTab: (tabName) {
          eventBus.fire(SwitchBottomNav(tabName));
        });
      }
    });

    ref.listen(emailLinkAuthProvider, (_, next) {
      _handleEmailLinkAuthState(globalContext!, next);
    });

    ref.listen(authActionProvider, (_, next) {
      _handleAuthActionState(globalContext!, next);
    });

    ref.listen(submissionSaveStateProvider, (_, next) {
      switch (next.value) {
        case SubmissionSaveStateFailed(:final error):
          final message = error is TasksOperationException
              ? error.toString()
              : "保存に失敗しました。";
          showSnackBar(globalContext!, message);
        case _:
          break;
      }
    });

    ref.listen(firebaseUserProvider, (prev, next) {
      if (prev?.value != null && next.value == null) {
        backToWelcomePage(globalContext!);
      }
    });

    final textTheme = const TextTheme(
      bodySmall: TextStyle(
        height: 1.2,
      ),
      // default
      bodyMedium: TextStyle(
        height: 1.2,
      ),
      bodyLarge: TextStyle(
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
      ),
      titleMedium: TextStyle(
        fontFamily: "Murecho",
      ),
      titleLarge: TextStyle(
        fontFamily: "Murecho",
      ),
      headlineMedium: TextStyle(
        fontFamily: "Murecho",
      ),
      displayMedium: TextStyle(
        fontFamily: "Murecho",
        height: 1.1,
      ),
      displayLarge: TextStyle(
        fontFamily: "Murecho",
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      labelLarge: TextStyle(
        fontFamily: "Murecho",
      ),
      // button etc...
    ).apply(
      fontFamily: "Murecho",
    );

    const pageTransitionsTheme = PageTransitionsTheme(builders: {
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
    });
    return MaterialApp(
      title: "Submon",
      debugShowCheckedModeBanner: !screenShotMode,
      navigatorKey: Application.globalKey,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: ref.watch(analyticsProvider))
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.black45,
            selectedItemColor: Colors.black),
        pageTransitionsTheme: pageTransitionsTheme,
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.lightGreen, brightness: Brightness.dark),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey, selectedItemColor: Colors.white),
        pageTransitionsTheme: pageTransitionsTheme,
        textTheme: ThemeData.dark().textTheme.merge(textTheme),
      ),
      supportedLocales: const [Locale("ja", "JP")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute:
          ref.watch(firebaseAuthProvider).currentUser == null && screenShotMode == false
              ? WelcomePage.routeName
              : HomePage.routeName,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case HomePage.routeName:
            return generatePageRoute((context) => const HomePage(), settings);
          case WelcomePage.routeName:
            return generatePageRoute(
                (context) => const WelcomePage(), settings);
          case FocusTimerPage.routeName:
            final args = settings.arguments as FocusTimerPageArguments;
            return generatePageRoute<bool>(
                (context) => FocusTimerPage(digestive: args.digestive),
                settings);
          case SubmissionEditPage.routeName:
            final args = settings.arguments as SubmissionEditPageArguments;
            return generatePageRoute(
                (context) => SubmissionEditPage(args.submissionId), settings);
          case CreateSubmissionPage.routeName:
            final args = settings.arguments as CreateSubmissionPageArguments;
            return generatePageRoute<void>(
                (context) => CreateSubmissionPage(
                    initialTitle: args.initialTitle,
                    initialDeadline: args.initialDeadline),
                settings);
          case SubmissionDetailPage.routeName:
            final args = settings.arguments as SubmissionDetailPageArguments;
            return generatePageRoute(
                (context) => SubmissionDetailPage(args.submissionId), settings);
          case TimetableEditPage.routeName:
            return generatePageRoute(
                (context) => const TimetableEditPage(), settings);
          case TimetableTableViewPage.routeName:
            return generatePageRoute(
                (context) => const TimetableTableViewPage(), settings);
          case DoneSubmissionsPage.routeName:
            return generatePageRoute(
                (context) => const DoneSubmissionsPage(), settings);
          case SignInPage.routeName:
            final args = settings.arguments as SignInPageArguments;
            return generatePageRoute<bool>(
              (context) => SignInPage(
                initialCred: args.initialCred,
                mode: args.mode,
                continueUri: args.continueUri,
              ),
              settings,
            );
          case EmailSignInPage.routeName:
            final args = settings.arguments as EmailSignInPageArguments;
            return generatePageRoute<bool>(
                (context) => EmailSignInPage(mode: args.mode), settings);
          case EmailRegistrationPage.routeName:
            final args = settings.arguments as EmailRegistrationPageArguments;
            return generatePageRoute<bool>(
                (context) => EmailRegistrationPage(email: args.email),
                settings);
          case CustomizeSettingsPage.routeName:
            return generatePageRoute(
                (context) =>
                    const SettingsPage("カスタマイズ設定", CustomizeSettingsPage()),
                settings);
          case FunctionsSettingsPage.routeName:
            return generatePageRoute(
                (context) =>
                    const SettingsPage("機能設定", FunctionsSettingsPage()),
                settings);
          case GeneralSettingsPage.routeName:
            return generatePageRoute(
                (context) => const SettingsPage("全般", GeneralSettingsPage()),
                settings);
          case TimetableSettingsPage.routeName:
            return generatePageRoute(
                (context) =>
                    const SettingsPage("時間割表設定", TimetableSettingsPage()),
                settings);
          case AccountLinkPage.routeName:
            return generatePageRoute(
                (context) =>
                    const SettingsPage("外部アカウント連携設定", AccountLinkPage()),
                settings);
          case GoogleTasksSettingsPage.routeName:
            return generatePageRoute(
                (context) => const SettingsPage(
                    "Google Tasksと連携", GoogleTasksSettingsPage()),
                settings);
          case AccountEditPage.changeEmailRouteName:
            return generatePageRoute(
                (context) => AccountEditPage(EditingType.changeEmail,
                    args: settings.arguments as AccountEditPageArguments?),
                settings);
          case AccountEditPage.changePasswordRouteName:
            return generatePageRoute(
                (context) => AccountEditPage(EditingType.changePassword),
                settings);
          case AccountEditPage.changeDisplayNameRouteName:
            return generatePageRoute(
                (context) => AccountEditPage(EditingType.changeDisplayName),
                settings);
          case AccountEditPage.deleteRouteName:
            return generatePageRoute(
                (context) => AccountEditPage(EditingType.delete), settings);
          default:
            return null;
        }

        // "/memorize_card/create": (context) => const MemorizeCardCreatePage(),
        // "/memorize_card/view": (context) =>
        // CardViewPage(arguments: settings.arguments),
        // "/memorize_card/test": (context) => const CardTestPage(),
        // "/memorize_card/graph": (context) => const CardGraphPage(),
        // "/memorize_card/forum": (context) => const CardForumPage(),
      },
    );
  }

  PageRoute<T> generatePageRoute<T>(
      WidgetBuilder builder, RouteSettings settings) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoPageRoute<T>(
          builder: builder, title: "asdf", settings: settings);
    } else {
      return MaterialPageRoute<T>(builder: builder, settings: settings);
    }
  }

  void _handleEmailLinkAuthState(
    BuildContext context,
    EmailLinkAuthState state,
  ) {
    if (state is! AuthActionStateProcessing) {
      closeLoadingModal(context);
    }

    switch (state) {
      case EmailLinkAuthStateSignInSucceeded(:final result):
        showSnackBar(context, signInSuccessMessage(result));
        Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.routeName,
          (route) => false,
        );
      case EmailLinkAuthStateReAuthSucceeded(:final destination):
        Navigator.of(context).pushNamed(
          destination.routeName,
          arguments: destination.routeArguments,
        );
      case EmailLinkAuthStateUpgradeSucceeded():
        showSnackBar(context, "アカウントをアップグレードしました。");
      case EmailLinkAuthStateFailed(:final error):
        showSnackBar(
          context,
          authErrorMessage(error),
          duration: Duration(seconds: 20),
        );
      case EmailLinkAuthStateProcessing():
        showLoadingModal(context);
      case EmailLinkAuthStateIdle():
    }
  }

  void _handleAuthActionState(
    BuildContext context,
    AuthActionState state,
  ) {
    if (state is! AuthActionStateProcessing) {
      closeLoadingModal(context);
    }

    switch (state) {
      case AuthActionStateSignedOut():
        backToWelcomePage(context);
      case AuthActionStateFailed(:final error):
        showSnackBar(
          context,
          authErrorMessage(error),
          duration: Duration(seconds: 20),
        );
      case AuthActionStateProcessing():
        showLoadingModal(context);
      case AuthActionStateIdle():
    }
  }

}

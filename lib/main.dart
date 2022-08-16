import 'dart:async';
import 'dart:io';

import 'package:animations/animations.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/tasks/v1.dart' as tasks;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/models/sign_in_result.dart';
import 'package:submon/pages/done_submissions_page.dart';
import 'package:submon/pages/email_registration_page.dart';
import 'package:submon/pages/email_sign_in_page.dart';
import 'package:submon/pages/focus_timer_page.dart';
import 'package:submon/pages/home_page.dart';
import 'package:submon/pages/settings/account_edit_page.dart';
import 'package:submon/pages/settings/canvas_lms_sync.dart';
import 'package:submon/pages/settings/customize.dart';
import 'package:submon/pages/settings/functions.dart';
import 'package:submon/pages/settings/general.dart';
import 'package:submon/pages/settings/google_tasks.dart';
import 'package:submon/pages/settings/timetable.dart';
import 'package:submon/pages/settings_page.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/pages/submission_edit_page.dart';
import 'package:submon/pages/timetable_edit_page.dart';
import 'package:submon/pages/timetable_table_view_page.dart';
import 'package:submon/pages/welcome_page.dart';

var scopes = [tasks.TasksApi.tasksScope];
var googleSignIn = GoogleSignIn(scopes: scopes);

const screenShotMode = bool.fromEnvironment("SCREENSHOT_MODE");

BuildContext? get globalContext => Application.globalKey.currentContext;

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    googleSignIn.signInSilently();
    MobileAds.instance.initialize();
    // getTemporaryDirectory().then((value) async {
    //   var directory = Directory(p.join(value.path, tempImgDirName));
    //   if (await directory.exists()) {
    //     directory.delete(recursive: true);
    //   }
    // });
    LicenseRegistry.addLicense(() async* {
      yield LicenseEntryWithLineBreaks(["google_fonts"],
          await rootBundle.loadString('assets/google_fonts/Murecho/OFL.txt'));
      yield LicenseEntryWithLineBreaks(["google_fonts"],
          await rootBundle.loadString('assets/google_fonts/B612_Mono/OFL.txt'));
      yield LicenseEntryWithLineBreaks(["google_fonts"],
          await rootBundle.loadString('assets/google_fonts/Play/OFL.txt'));
    });
    runApp(const Application());
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  static var globalKey = GlobalKey<NavigatorState>();

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var _initialized = false;
  var _initializingErrorOccurred = false;

  @override
  void initState() {
    initFirebase();
    SharedPrefs.use((prefs) async {
      prefs.lastVersionCode =
          int.parse((await PackageInfo.fromPlatform()).buildNumber);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_initializingErrorOccurred) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.redAccent,
            title: const Text("エラー"),
          ),
          body: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
                "Firebaseの準備に失敗しました。アプリを再起動してください。\n再起動しても改善されない場合は、開発者Twitter (@chikavoid) のDMでご連絡ください。"),
          ),
        ),
      );
    }
    if (!_initialized) {
      return Container();
    }

    var textTheme = const TextTheme(
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
      title: 'Submon',
      debugShowCheckedModeBanner: !screenShotMode,
      navigatorKey: Application.globalKey,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)
      ],
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.black45,
            selectedItemColor: Colors.black),
        pageTransitionsTheme: pageTransitionsTheme,
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.lightGreen,
        brightness: Brightness.dark,
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
          FirebaseAuth.instance.currentUser == null && screenShotMode == false
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
            var args = settings.arguments as FocusTimerPageArguments;
            return generatePageRoute<bool>(
                (context) => FocusTimerPage(digestive: args.digestive),
                settings);
          case SubmissionEditPage.routeName:
            var args = settings.arguments as SubmissionEditPageArguments;
            return generatePageRoute(
                (context) => SubmissionEditPage(args.submissionId), settings);
          case CreateSubmissionPage.routeName:
            var args = settings.arguments as CreateSubmissionPageArguments;
            return generatePageRoute<int>(
                (context) => CreateSubmissionPage(
                    initialTitle: args.initialTitle,
                    initialDeadline: args.initialDeadline),
                settings);
          case SubmissionDetailPage.routeName:
            var args = settings.arguments as SubmissionDetailPageArguments;
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
            var args = settings.arguments as SignInPageArguments;
            return generatePageRoute<bool>(
                (context) => SignInPage(
                      initialCred: args.initialCred,
                      mode: args.mode,
                    ),
                settings);
          case EmailSignInPage.routeName:
            var args = settings.arguments as EmailSignInPageArguments;
            return generatePageRoute<SignInResult>(
                (context) => EmailSignInPage(reAuth: args.reAuth), settings);
          case EmailRegistrationPage.routeName:
            var args = settings.arguments as EmailRegistrationPageArguments;
            return generatePageRoute<UserCredential>(
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
          case GoogleTasksSettingsPage.routeName:
            return generatePageRoute(
                (context) => const SettingsPage(
                    "Google Tasksと連携", GoogleTasksSettingsPage()),
                settings);
          case CanvasLmsSyncSettingsPage.routeName:
            return generatePageRoute(
                (context) => const SettingsPage(
                    "Canvas と連携", CanvasLmsSyncSettingsPage()),
                settings);
          case AccountEditPage.changeEmailRouteName:
            return generatePageRoute(
                (context) => const AccountEditPage(EditingType.changeEmail),
                settings);
          case AccountEditPage.changePasswordRouteName:
            return generatePageRoute(
                (context) => const AccountEditPage(EditingType.changePassword),
                settings);
          case AccountEditPage.changeDisplayNameRouteName:
            return generatePageRoute(
                (context) =>
                    const AccountEditPage(EditingType.changeDisplayName),
                settings);
          case AccountEditPage.deleteRouteName:
            return generatePageRoute(
                (context) => const AccountEditPage(EditingType.delete),
                settings);
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

  void initFirebase() async {
    try {
      await Firebase.initializeApp();
      MainMethodPlugin.initHandler();
      if (!screenShotMode) {
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      }
      if (kDebugMode) {
        FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
      FirebaseAuth.instance.authStateChanges().listen((event) {
        setState(() {
          _initialized = true;
        });
      });
    } catch (e) {
      setState(() {
        _initializingErrorOccurred = true;
      });
    }
  }
}

import 'dart:io';

import 'package:animations/animations.dart';
import 'package:camera/camera.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:submon/method_channel/main.dart';
import 'package:submon/pages/done_submissions_page.dart';
import 'package:submon/pages/email_login_page.dart';
import 'package:submon/pages/focus_timer_page.dart';
import 'package:submon/pages/home_page.dart';
import 'package:submon/pages/link_with_google_tasks_page.dart';
import 'package:submon/pages/memorize_card/camera_preview_page.dart';
import 'package:submon/pages/memorize_card/card_forum_page.dart';
import 'package:submon/pages/memorize_card/card_graph_page.dart';
import 'package:submon/pages/memorize_card/card_test_page.dart';
import 'package:submon/pages/memorize_card/card_view_page.dart';
import 'package:submon/pages/memorize_card/memorize_card_create_page.dart';
import 'package:submon/pages/settings/account_edit_page.dart';
import 'package:submon/pages/settings/canvas_lms_sync_page.dart';
import 'package:submon/pages/settings/customize.dart';
import 'package:submon/pages/settings/functions.dart';
import 'package:submon/pages/settings/general.dart';
import 'package:submon/pages/settings/timetable.dart';
import 'package:submon/pages/settings_page.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/pages/submission_create_page.dart';
import 'package:submon/pages/submission_detail_page.dart';
import 'package:submon/pages/submission_edit_page.dart';
import 'package:submon/pages/timetable_edit_page.dart';
import 'package:submon/pages/timetable_table_view_page.dart';
import 'package:submon/pages/welcome_page.dart';

late List<CameraDescription> cameras;

var scopes = [tasks.TasksApi.tasksScope];
var googleSignIn = GoogleSignIn(scopes: scopes);

const screenShotMode = false;

BuildContext? get globalContext => Application.globalKey.currentContext;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  cameras = await availableCameras();
  googleSignIn.signInSilently();
  MobileAds.instance.initialize();
  getTemporaryDirectory().then((value) async {
    var directory = Directory(p.join(value.path, tempImgDirName));
    if (await directory.exists()) {
      directory.delete(recursive: true);
    }
  });
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(["google_fonts"],
        await rootBundle.loadString('assets/google_fonts/Murecho/OFL.txt'));
    yield LicenseEntryWithLineBreaks(["google_fonts"],
        await rootBundle.loadString('assets/google_fonts/B612_Mono/OFL.txt'));
    yield LicenseEntryWithLineBreaks(["google_fonts"],
        await rootBundle.loadString('assets/google_fonts/Play/OFL.txt'));
  });
  runApp(const Application());
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
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
        textTheme: textTheme,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.lightGreen,
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            unselectedItemColor: Colors.grey, selectedItemColor: Colors.white),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: SharedAxisPageTransitionsBuilder(
              transitionType: SharedAxisTransitionType.scaled),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }),
        textTheme: ThemeData.dark().textTheme.merge(textTheme),
      ),
      supportedLocales: const [Locale("ja", "JP")],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: FirebaseAuth.instance.currentUser == null ? "welcome" : "/",
      onGenerateRoute: (settings) {
        var routes = <String, WidgetBuilder>{
          "/": (context) => const HomePage(),
          "welcome": (context) => const WelcomePage(),
          "/focus-timer": (context) =>
              FocusTimerPage(arguments: settings.arguments as dynamic),
          "/submission/edit": (context) => SubmissionEditPage(
              (settings.arguments as dynamic)["submissionId"]),
          "/submission/create": (context) => SubmissionCreatePage(
            initialTitle: (settings.arguments as dynamic)["initialTitle"],
            initialDeadline:
            (settings.arguments as dynamic)["initialDeadline"],
          ),
          "/submission/detail": (context) => SubmissionDetailPage(
            (settings.arguments as dynamic)["id"],
          ),
          "/timetable/edit": (context) => const TimetableEditPage(),
          "/timetable/table-view": (context) => const TimetableTableViewPage(),
          "/memorize_card/camera": (context) =>
              CameraPreviewPage(arguments: settings.arguments),
          "/memorize_card/create": (context) => const MemorizeCardCreatePage(),
          "/memorize_card/view": (context) =>
              CardViewPage(arguments: settings.arguments),
          "/memorize_card/test": (context) => const CardTestPage(),
          "/memorize_card/graph": (context) => const CardGraphPage(),
          "/memorize_card/forum": (context) => const CardForumPage(),
          "/done": (context) => const DoneSubmissionsPage(),
          "/signIn": (context) => SignInPage(arguments: settings.arguments),
          "/signIn/email": (context) => EmailLoginPage(
              reAuth: (settings.arguments as dynamic)?["reAuth"] ?? false),
          "/settings/customize": (context) =>
          const SettingsPage("カスタマイズ設定", page: CustomizeSettingsPage()),
          "/settings/functions": (context) =>
          const SettingsPage("機能設定", page: FunctionsSettingsPage()),
          "/settings/functions/link-with-google-tasks": (context) =>
          const LinkWithGoogleTasksPage(),
          "/settings/functions/canvasLmsSync": (context) =>
          const CanvasLmsSyncPage(),
          "/settings/general": (context) =>
          const SettingsPage("全般", page: GeneralSettingsPage()),
          "/settings/timetable": (context) =>
          const SettingsPage("時間割表設定", page: TimetableSettingsPage()),
          "/account/changeEmail": (context) =>
          const AccountEditPage(EditingType.changeEmail),
          "/account/changePassword": (context) =>
          const AccountEditPage(EditingType.changePassword),
          "/account/changeDisplayName": (context) =>
          const AccountEditPage(EditingType.changeDisplayName),
          "/account/delete": (context) =>
          const AccountEditPage(EditingType.delete),
        };
        if (Platform.isIOS || Platform.isMacOS) {
          return CupertinoPageRoute(
              builder: routes[settings.name]!, settings: settings);
        } else {
          return MaterialPageRoute(
              builder: routes[settings.name]!, settings: settings);
        }
      },
    );
  }

  void initFirebase() async {
    try {
      await Firebase.initializeApp();
      MainMethodPlugin.initHandler();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
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
import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var _disableStatistics = false;
  StreamSubscription? linkListener;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    Application.globalKey = _scaffoldKey;

    linkListener = eventBus.on<SignedInWithLink>().listen((_) {
      Navigator.of(context).popUntil(ModalRoute.withName("welcome"));
      Navigator.of(context).pushReplacementNamed("/");
    });
  }

  @override
  void dispose() {
    linkListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('ようこそ'),
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                const SizedBox(height: 32),
                Text('Submon',
                    style: GoogleFonts.exo(
                        fontSize: 50, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('簡単に提出物を一括管理', style: TextStyle(fontSize: 15)),
                const SizedBox(height: 160),
                SizedBox(
                  height: 55,
                  width: 240,
                  child: ElevatedButton(
                    child: const Text('ログインして始める',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      var result =
                      await Navigator.pushNamed(context, "/signIn");
                      if (result == true) {
                        Navigator.pushReplacementNamed(context, "/");
                      }
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 40,
                  width: 240,
                  child: ElevatedButton(
                    child: const Text('お試しモードで開始',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    onPressed: () async {
                      showSimpleDialog(
                          context,
                          "お試しモード利用上の注意",
                          "お試しモードでは、アカウントを作成することなくオフラインでアプリを利用することができます。お試しモード利用時、以下の機能はご利用いただけません。\n\n"
                              "・ホーム画面のウィジェット\n"
                              "・各種通知機能\n"
                              "・ 暗記カードのカメラ入力",
                          okText: "お試しモードで開始",
                          showCancel: true,
                          onOKPressed: () {});
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                  ),
                ),
                const SizedBox(height: 48),
                SizedBox(
                  height: 70,
                  width: 240,
                  child: ElevatedButton(
                    child: const Text('旧「提出物マネージャー」\nからアカウント移行',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    onPressed: () async {
                      showSimpleDialog(
                          context,
                          "アカウント移行の流れについて",
                          "アカウントのデータを旧「提出物マネージャー」から移行できます。アカウント移行専用ページを用意しましたので、アカウントは新規に作成し、データのみ旧版から移行する形になります。\n\n"
                              "「次へ」をタップすると移行用サイトに移動します。詳細はこのサイトをご覧ください。",
                          okText: "次へ",
                          showCancel: true, onOKPressed: () async {
                        launch("https://submon.chikach.net/migrate",
                            forceSafariVC: true);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange.shade700),
                  ),
                ),
                const SizedBox(height: 32),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'アカウント作成は必要ありません。\nログインしようとすることでアカウントが作成できます。',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      value: _disableStatistics,
                      activeColor: Colors.red,
                      onChanged: (value) {
                        FirebaseAnalytics.instance
                            .setAnalyticsCollectionEnabled(!value!);
                        SharedPrefs.use((prefs) {
                          prefs.isAnalyticsEnabled = !value;
                        });
                        setState(() {
                          _disableStatistics = value;
                        });
                      },
                    ),
                    Flexible(
                      child: Text(
                        'アプリの改善に利用する使用状況データ(匿名)の収集を拒否する',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .color!
                                .withOpacity(0.7)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

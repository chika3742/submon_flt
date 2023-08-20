import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:submon/auth/sign_in_handler.dart';
import 'package:submon/browser.dart';
import 'package:submon/db/firestore_provider.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/main.dart';
import 'package:submon/pages/sign_in_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'home_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  static const routeName = "welcome";

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  var _disableStatistics = false;
  final _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('ようこそ'),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  const Text('Submon',
                      style: TextStyle(
                        fontFamily: "Play",
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 8),
                  const Text('簡単に提出物を一括管理', style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 96),
                  SizedBox(
                    height: 55,
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () async {
                        var result = await Navigator.pushNamed(
                            context, SignInPage.routeName,
                            arguments:
                                const SignInPageArguments(SignInMode.normal));
                        if (result == true && mounted) {
                          Navigator.pushReplacementNamed(
                              context, HomePage.routeName);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      child: const Text('ログインして始める',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 40,
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () async {
                        showSimpleDialog(
                          context,
                          "お試しモードについて",
                          "お試しモードでは、個人情報を入力することなくアプリを利用することができます。\n\n他の端末にデータを移行することはできません。後から通常アカウントにアップグレードすることが出来ます。\n\n"
                              "※アプリをアンインストールしたり、データを削除したりすると、永久にデータが使えなくなります。ご注意ください。",
                          okText: "お試しモードで開始",
                          showCancel: true,
                          reverseOkCancelOrderOnApple: true,
                          onOKPressed: () async {
                            showLoadingModal(context);

                            try {
                              await FirebaseAuth.instance.signInAnonymously();
                              await FirestoreProvider.initializeUser();

                              showSnackBar(globalContext!, "お試しモードでスタートしました！");
                            } catch (e) {
                              showSnackBar(context, "エラーが発生しました");
                            }

                            Navigator.pop(globalContext!);
                            Navigator.pushReplacementNamed(
                                globalContext!, HomePage.routeName);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey),
                      child: const Text('お試しモードで開始',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      '面倒なアカウント作成手続きは不要。\n\n'
                      '続けるには、「利用規約」「プライバシーポリシー」に同意する必要があります。',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: Browser.openTermsOfUse,
                        child: Text('利用規約'),
                      ),
                      OutlinedButton(
                        onPressed: Browser.openPrivacyPolicy,
                        child: Text('プライバシーポリシー'),
                      ),
                    ],
                  ),
                  if (!kIsWeb && (Platform.isIOS || Platform.isMacOS))
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'ログイン後、「他社のAppやWebサイトを横断してトラッキング'
                        'することを許可」するか尋ねるダイアログが表示される'
                        '場合があります。これは最適な広告表示のためのものです。',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 70,
                    width: 240,
                    child: ElevatedButton(
                      onPressed: () async {
                        showSimpleDialog(
                            context,
                            "アカウント移行の流れについて",
                            "アカウントのデータを旧「提出物マネージャー」から移行できます。アカウント移行専用ページを用意しましたので、アカウントは新規に作成し、データのみ旧版から移行する形になります。\n\n"
                                "「次へ」をタップすると移行用サイトに移動します。詳細はこのサイトをご覧ください。",
                            okText: "次へ",
                            showCancel: true, onOKPressed: () async {
                          launchUrlString("https://submon.chikach.net/migrate",
                              mode: LaunchMode.externalApplication);
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade900),
                      child: const Text('旧「提出物マネージャー」\nからアカウント移行',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center),
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
                        child: Text.rich(
                          const TextSpan(children: [
                            TextSpan(text: 'アプリの改善に利用する使用状況データ(匿名)の収集を'),
                            TextSpan(
                                text: '拒否',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: 'する'),
                          ]),
                          style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .color!
                                  .withOpacity(0.7)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

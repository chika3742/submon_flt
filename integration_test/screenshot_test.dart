import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:submon/main.dart' as app;

void main() {
  final IntegrationTestWidgetsFlutterBinding binding = IntegrationTestWidgetsFlutterBinding();

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets("screenshot", (tester) async {
    app.main();

    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
    }

    await tester.pump();

    // wait for initialize
    await tester.pump(const Duration(seconds: 3));
    // take screenshot of home screen
    await takeScreenshot(binding, 1);
    print("ss1 took");

    // show submission detail page
    await tester.tap(find.text("提出物1"));
    await tester.pumpAndSettle();
    // take ss of submission detail page
    await takeScreenshot(binding, 2);
    print("ss2 took");
    // back
    await tester.tap(find.byTooltip("戻る"));
    await tester.pump(const Duration(seconds: 1));

    // tap digestive tab
    await tester.tap(find.byIcon(Icons.task));
    // wait for initialize
    await tester.pump(const Duration(seconds: 1));
    // take screenshot of digestive list
    await takeScreenshot(binding, 3);
    print("ss3 took");

    // tap timetable tab
    await tester.tap(find.byIcon(Icons.table_chart_outlined));
    await tester.pump(const Duration(seconds: 1));
    // take ss of timetable
    await takeScreenshot(binding, 4);
    print("ss4 took");
  });
}

Future<void> takeScreenshot(IntegrationTestWidgetsFlutterBinding binding, int index) async {
  await binding.takeScreenshot("${const String.fromEnvironment("SCREENSHOT_NAME")}_$index");
}

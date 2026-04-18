import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:submon/features/auth/ui/components/sign_in_method_button.dart";

void main() {
  Widget buildTestWidget({
    bool isLoading = false,
    Color color = Colors.white,
    VoidCallback? onPressed,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: SignInMethodButton(
          icon: Icon(Icons.login),
          methodName: "Google",
          color: color,
          isLoading: isLoading,
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }

  group("SignInMethodButton", () {
    testWidgets("displays method name text in normal state", (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text("Googleでサインイン"), findsOneWidget);
    });

    testWidgets("shows CircularProgressIndicator when loading", (tester) async {
      await tester.pumpWidget(buildTestWidget(isLoading: true));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text("Googleでサインイン"), findsNothing);
    });

    testWidgets("button is disabled when loading", (tester) async {
      var pressed = false;
      await tester.pumpWidget(buildTestWidget(
        isLoading: true,
        onPressed: () => pressed = true,
      ));

      await tester.tap(find.byType(ElevatedButton));
      expect(pressed, isFalse);
    });

    testWidgets("uses dark text on light background", (tester) async {
      await tester.pumpWidget(buildTestWidget(color: Colors.white));

      final textWidget = tester.widget<Text>(
        find.text("Googleでサインイン"),
      );
      expect(textWidget.style?.color, Colors.black87);
    });

    testWidgets("uses white text on dark background", (tester) async {
      await tester.pumpWidget(buildTestWidget(color: Colors.blueGrey));

      final textWidget = tester.widget<Text>(
        find.text("Googleでサインイン"),
      );
      expect(textWidget.style?.color, Colors.white);
    });
  });
}

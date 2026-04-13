import "package:flutter/material.dart";

class SignInMethodButton extends StatelessWidget {
  final Widget icon;
  final String methodName;
  final Color color;
  final bool isLoading;
  final VoidCallback? onPressed;

  const SignInMethodButton({
    super.key,
    required this.icon,
    required this.methodName,
    required this.color,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: color,
      disabledBackgroundColor: Colors.grey,
      fixedSize: Size(250, 50),
    );
    return !isLoading
        ? ElevatedButton.icon(
            icon: icon,
            style: buttonStyle,
            label: Text("$methodNameでサインイン", style: TextStyle(
              color: ThemeData.estimateBrightnessForColor(color) == Brightness.light
                  ? Colors.black87
                  : Colors.white,
              fontWeight: .bold,
            )),
            onPressed: onPressed,
          )
        : ElevatedButton(
            style: buttonStyle,
            onPressed: null,
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
  }
}

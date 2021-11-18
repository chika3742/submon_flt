import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ログイン / 新規登録'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Text("続行するには、以下の利用規約・プライバシーポリシーに同意する必要があります。"),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text("利用規約"),
                      onPressed: () {

                      },
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      child: const Text("プライバシーポリシー"),
                      onPressed: () {

                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.mail),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.orange
                    ),
                    label: const Text("メールアドレスでログイン"),
                    onPressed: () {

                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      "assets/vector/apple.svg",
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blueGrey
                    ),
                    label: const Text("Appleでログイン", style: TextStyle(color: Colors.white)),
                    onPressed: () {

                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      "assets/vector/google.svg",
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white
                    ),
                    label: const Text("Googleでログイン"),
                    onPressed: () {

                    },
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 250,
                  child: ElevatedButton.icon(
                    icon: SvgPicture.asset(
                      "assets/vector/twitter.svg",
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: const Color(0xff1da1f2)
                    ),
                    label: const Text("Twitterでログイン", style: TextStyle(color: Colors.white)),
                    onPressed: () {

                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

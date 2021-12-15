import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ようこそ'),
        ),
        body: SizedBox.expand(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Submon',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ),
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
                    var result = await Navigator.pushNamed(context, "/signIn");
                    if (result == true) {
                      Navigator.pushReplacementNamed(context, "/");
                    }
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('ログインは必要ありません。ログインしようとすることでアカウントが作成できます。'),
              ),
            ],
          ),
        ));
  }
}

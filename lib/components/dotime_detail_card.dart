import 'package:flutter/material.dart';

class DoTimeDetailCard extends StatefulWidget {
  const DoTimeDetailCard(
      {Key? key, required this.submissionId, required this.doTimeId})
      : super(key: key);

  final int submissionId;
  final int doTimeId;

  @override
  _DoTimeDetailCardState createState() => _DoTimeDetailCardState();
}

class _DoTimeDetailCardState extends State<DoTimeDetailCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "2", style: TextStyle(fontSize: 20)),
                    TextSpan(text: "月 ", style: TextStyle(fontSize: 16)),
                    TextSpan(text: "24", style: TextStyle(fontSize: 20)),
                    TextSpan(text: "日", style: TextStyle(fontSize: 16)),
                  ], style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 8),
                  Text.rich(TextSpan(children: [
                    TextSpan(text: "15:00", style: TextStyle(fontSize: 20)),
                    TextSpan(text: "〜", style: TextStyle(fontSize: 16)),
                  ], style: TextStyle(fontWeight: FontWeight.bold))),
                  SizedBox(width: 16),
                  Text.rich(TextSpan(children: [
                    TextSpan(
                        text: "30",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                    TextSpan(
                        text: "分",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ])),
                  Spacer(),
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: PopupMenuButton(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            child: ListTile(
                              title: Text("編集"),
                              leading: Icon(Icons.edit),
                            ),
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              title: Text("削除"),
                              leading: Icon(Icons.delete),
                            ),
                          ),
                        ];
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text('asdads', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}

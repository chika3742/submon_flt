import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/formatted_date_remaining.dart';
import 'package:submon/db/submission.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage(this.submissionId, {Key? key}) : super(key: key);

  final int submissionId;

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  Submission? item;

  @override
  void initState() {
    super.initState();
    SubmissionProvider().use((provider) {
      provider.get(widget.submissionId).then((value) {
        setState(() {
          item = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("詳細"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, "/submission/edit",
                  arguments: {"submissionId": widget.submissionId});
              SubmissionProvider().use((provider) {
                provider.get(widget.submissionId).then((value) {
                  setState(() {
                    item = value;
                  });
                });
              });
            },
          )
        ],
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item != null) Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item!.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            ),
            const Divider(thickness: 2, indent: 32),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  const Icon(Icons.event_available),
                  const SizedBox(width: 8),
                  if (item != null) Text(DateFormat("MM/dd (E)", 'ja_JP').format(item!.date!), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Spacer(),
                  const Icon(Icons.schedule),
                  const SizedBox(width: 8),
                  if (item != null) FormattedDateRemaining(item!.date!.difference(DateTime.now()), numberSize: 24),
                ],
              ),
            ),
            if (item != null) Padding(
              padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            // child: Text(item!.detail, style: const TextStyle(fontSize: 16, height: 1.3)),
            child: SizedBox(
              height: 200,
              child: Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: item!.detail,
                style: const TextStyle(fontSize: 16, height: 1.7),
              ),
            ),
          )
          ]
      ),
    );
  }
}
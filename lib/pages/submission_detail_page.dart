import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:submon/local_db/submission.dart';
import 'package:submon/shared_axis_page_route.dart';
import 'package:submon/utils.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage(this.submissionId, {Key? key}) : super(key: key);

  final int submissionId;

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("詳細")),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) => SharedAxisPageRoute(SubmissionDetail(widget.submissionId)),
      ),
    );
  }
}

class SubmissionDetail extends StatefulWidget {
  const SubmissionDetail(this.submissionId, {Key? key}) : super(key: key);

  final int submissionId;

  @override
  _SubmissionDetailState createState() => _SubmissionDetailState();
}

class _SubmissionDetailState extends State<SubmissionDetail> {
  Submission? item;

  @override
  void initState() {
    super.initState();
    SubmissionProvider.use((provider) {
      provider.getSubmission(widget.submissionId, [colTitle, colDate, colDetail]).then((value) {
        setState(() {
          item = value;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var remainingDate = item!.date!.difference(DateTime.now()).inDays;
    return Column(
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
              if (item != null) Text("$remainingDate 日", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: getRemainingDateColor(remainingDate))),
            ],
          ),
        ),
        if (item != null) Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
          child: Text(item!.detail!, style: const TextStyle(fontSize: 16)),
        )
      ]
    );
  }
}

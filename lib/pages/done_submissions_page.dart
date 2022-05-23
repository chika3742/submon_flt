import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:submon/components/submission_list.dart';

class DoneSubmissionsPage extends StatefulWidget {
  const DoneSubmissionsPage({Key? key}) : super(key: key);

  @override
  _DoneSubmissionsPageState createState() => _DoneSubmissionsPageState();
}

class _DoneSubmissionsPageState extends State<DoneSubmissionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.doneSubmissions),
        ),
        body: const SubmissionList(done: true));
  }
}

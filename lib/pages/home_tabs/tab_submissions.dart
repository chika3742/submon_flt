import 'package:flutter/material.dart';
import 'package:submon/components/submission_list.dart';

class TabSubmissions extends StatefulWidget {
  const TabSubmissions({Key? key}) : super(key: key);

  @override
  _TabSubmissionsState createState() => _TabSubmissionsState();
}

class _TabSubmissionsState extends State<TabSubmissions> {
  @override
  Widget build(BuildContext context) {
    return const SubmissionList();
  }
}

import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_list.dart';

class TabSubmissions extends StatefulWidget {
  const TabSubmissions({super.key});

  @override
  _TabSubmissionsState createState() => _TabSubmissionsState();
}

class _TabSubmissionsState extends State<TabSubmissions> {
  @override
  Widget build(BuildContext context) {
    return const SubmissionList();
  }
}

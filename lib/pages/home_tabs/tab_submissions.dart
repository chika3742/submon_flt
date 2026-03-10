import "package:flutter/material.dart";
import "../../components/submissions/submission_list.dart";

class TabSubmissions extends StatefulWidget {
  const TabSubmissions({super.key});

  @override
  TabSubmissionsState createState() => TabSubmissionsState();
}

class TabSubmissionsState extends State<TabSubmissions> {
  @override
  Widget build(BuildContext context) {
    return const SubmissionList();
  }
}

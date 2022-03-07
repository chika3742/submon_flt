import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/dotime_detail_card.dart';
import 'package:submon/components/dotime_edit_bottom_sheet.dart';
import 'package:submon/components/formatted_date_remaining.dart';
import 'package:submon/db/dotime.dart';
import 'package:submon/db/submission.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage(this.submissionId, {Key? key}) : super(key: key);

  final int submissionId;

  @override
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  Submission? item;
  List<DoTime> doTimes = [];

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
    DoTimeProvider().use((provider) async {
      var doTimes = await provider.getAll(
          where: "$colSubmissionId = ?", whereArgs: [widget.submissionId]);
      doTimes.sort((a, b) {
        return a.startAt.difference(b.startAt).inMinutes;
      });
      setState(() {
        this.doTimes = doTimes;
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: showCreateDoTimeBottomSheet,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (item != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(item!.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
            ),
          const Divider(thickness: 2, indent: 32, endIndent: 32),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(),
                const Icon(Icons.event_available),
                const SizedBox(width: 8),
                if (item != null)
                  Text(DateFormat("MM/dd (E)", 'ja_JP').format(item!.date!),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
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
                if (item != null)
                  FormattedDateRemaining(item!.date!.difference(DateTime.now()),
                      numberSize: 24),
              ],
            ),
          ),
          if (item != null)
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              // child: Text(item!.detail, style: const TextStyle(fontSize: 16, height: 1.3)),
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
          const Divider(thickness: 2, indent: 32, endIndent: 32),
          const Align(
            alignment: Alignment.center,
            child: Text('DoTime',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          ...doTimes
              .map((e) => DoTimeDetailCard(
                    submissionId: e.submissionId,
                    doTime: e,
                    onDelete: () {
                      onDoTimeDelete(e);
                    },
                    onEdit: () {
                      onDoTimeEdit(e);
                    },
                    onTimer: () {},
                  ))
              .toList(),
          if (doTimes.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Opacity(
                  opacity: 0.7,
                  child: Text(
                    'DoTimeがありません。右下の「+」から\n追加できます。',
                  ),
                ),
              ),
            ),
        ]),
      ),
    );
  }

  void showCreateDoTimeBottomSheet() async {
    var data = await showRoundedBottomSheet<DoTime>(
      context: context,
      title: "DoTime 新規作成",
      child: DoTimeEditBottomSheet(submissionId: widget.submissionId),
    );
    if (data != null) {
      DoTimeProvider().use((provider) async {
        await provider.insert(data);
      });
      setState(() {
        doTimes.add(data);
      });
    }
  }

  void onDoTimeDelete(DoTime e) async {
    await DoTimeProvider().use((provider) async {
      await provider.delete(e.id!);
    });
    var index = doTimes.indexOf(e);
    setState(() {
      doTimes.remove(e);
    });
    showSnackBar(context, "削除しました",
        action: SnackBarAction(
          label: "元に戻す",
          onPressed: () {
            DoTimeProvider().use((provider) async {
              await provider.insert(e);
            });
            setState(() {
              doTimes.insert(index, e);
            });
          },
        ));
  }

  void onDoTimeEdit(DoTime e) async {
    var data = await showRoundedBottomSheet<DoTime>(
      context: context,
      title: "編集",
      child: DoTimeEditBottomSheet(
        submissionId: widget.submissionId,
        initialData: e,
      ),
    );
    if (data != null) {
      await DoTimeProvider().use((provider) async {
        await provider.insert(data);
      });
      setState(() {
        var index = doTimes.indexOf(e);
        doTimes.removeAt(index);
        doTimes.insert(index, data);
      });
      showSnackBar(context, "編集しました");
    }
  }
}
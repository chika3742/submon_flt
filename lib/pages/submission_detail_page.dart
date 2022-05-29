import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:submon/components/digestive_detail_card.dart';
import 'package:submon/components/digestive_edit_bottom_sheet.dart';
import 'package:submon/components/submissions/formatted_date_remaining.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/ad_unit_ids.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage(this.submissionId, {Key? key}) : super(key: key);

  final int submissionId;

  @override
  // ignore: library_private_types_in_public_api
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  Submission? item;
  List<Digestive> _digestiveList = [];
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    SubmissionProvider().use((provider) async {
      await provider.get(widget.submissionId).then((value) {
        if (value == null) {
          showSnackBar(context, "提出物が見つかりません");
          Navigator.pop(context);
        }
        setState(() {
          item = value;
        });
      });
    });
    DigestiveProvider().use((provider) async {
      var digestives =
          await provider.getDigestivesBySubmissionId(widget.submissionId);
      setState(() {
        _digestiveList = digestives;
      });
    });

    if (!screenShotMode) {
      _bannerAd = BannerAd(
        adUnitId: AdUnits.submissionDetailBanner!,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: const BannerAdListener(),
      );

      _bannerAd!.load();
    }
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
              SubmissionProvider().use((provider) async {
                await provider.get(widget.submissionId).then((value) {
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
        onPressed: showCreateDigestiveBottomSheet,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                              Text(
                                  DateFormat("M/d (E)", 'ja_JP')
                                      .format(item!.due),
                                  style: const TextStyle(fontSize: 18)),
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
                              FormattedDateRemaining(
                                  item!.due.difference(DateTime.now()),
                                  numberSize: 24),
                          ],
                        ),
                      ),
                      if (item != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16.0, bottom: 16.0),
                          // child: Text(item!.detail, style: const TextStyle(fontSize: 16, height: 1.3)),
                          child: Linkify(
                            onOpen: (link) async {
                              if (await canLaunchUrlString(link.url)) {
                                await launchUrlString(link.url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },
                            text: item!.details,
                            style: const TextStyle(fontSize: 16, height: 1.7),
                          ),
                        ),
                      const Divider(thickness: 2, indent: 32, endIndent: 32),
                      const Align(
                        alignment: Alignment.center,
                        child: Text('Digestive',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      ..._digestiveList
                          .map((e) => DigestiveDetailCard(
                                digestive: e,
                                parentList: _digestiveList,
                                onChanged: () {
                                  setState(() {});
                                },
                              ))
                          .toList(),
                      if (_digestiveList.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                'Digestiveがありません。右下の「+」から\n追加できます。',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (_bannerAd != null)
              Container(
                alignment: Alignment.center,
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ),
    );
  }

  void showCreateDigestiveBottomSheet() async {
    var data = await showRoundedBottomSheet<Digestive>(
      context: context,
      title: "Digestive 新規作成",
      child: DigestiveEditBottomSheet(submissionId: widget.submissionId),
    );
    if (data != null) {
      DigestiveProvider().use((provider) async {
        provider.writeTransaction(() async {
          await provider.put(data);
        });
      });
      setState(() {
        _digestiveList.add(data);
      });
    }
  }
}

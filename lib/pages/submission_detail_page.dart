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
import 'package:submon/pages/submission_edit_page.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../sample_data.dart';
import '../utils/ad_unit_ids.dart';

class SubmissionDetailPage extends StatefulWidget {
  const SubmissionDetailPage(this.submissionId, {super.key});

  static const routeName = "/submission/detail";

  final int submissionId;

  @override
  // ignore: library_private_types_in_public_api
  _SubmissionDetailPageState createState() => _SubmissionDetailPageState();
}

enum SubmissionDetailPagePopAction { delete }

class SubmissionDetailPageArguments {
  final int submissionId;

  SubmissionDetailPageArguments(this.submissionId);
}

class _SubmissionDetailPageState extends State<SubmissionDetailPage> {
  Submission? item;
  List<Digestive> _digestiveList = [];
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    SubmissionProvider().use((provider) async {
      if (screenShotMode) {
        item = SampleData.submissions[0];
      } else {
        await provider.get(widget.submissionId).then((value) {
          if (value == null) {
            showSnackBar(context, "提出物が見つかりません");
            Navigator.pop(context);
          }
          setState(() {
            item = value;
          });
        });
      }
    });
    DigestiveProvider().use((provider) async {
      if (screenShotMode) {
        _digestiveList = [SampleData.digestives[0]];
      } else {
        _digestiveList =
        await provider.getDigestivesBySubmissionId(widget.submissionId);
      }
      setState(() {});
    });

    if (!screenShotMode && isAdEnabled) {
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
            icon: const Icon(Icons.delete),
            onPressed: () {
              Navigator.pop(context, SubmissionDetailPagePopAction.delete);
            },
          ),
          IconButton(
            icon: Icon(
                item?.important == true ? Icons.star : Icons.star_outline,
                color: item?.important == true ? Colors.yellowAccent : null),
            onPressed: () async {
              await SubmissionProvider().use((provider) {
                return provider.writeTransaction(() async {
                  item!.important = !item!.important;
                  await provider.put(item!);
                  setState(() {});
                });
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.pushNamed(context, SubmissionEditPage.routeName,
                  arguments: SubmissionEditPageArguments(widget.submissionId));
              SubmissionProvider().use((provider) async {
                await provider.get(widget.submissionId).then((value) {
                  setState(() {
                    item = value;
                  });
                });
              });
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: _bannerAd?.size.height.toDouble() ?? 0.0),
        child: FloatingActionButton(
          onPressed: showCreateDigestiveBottomSheet,
          child: const Icon(Icons.add),
        ),
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
                      if (item != null && item!.repeat != Repeat.none) Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            const Icon(Icons.repeat),
                            const SizedBox(width: 8),
                            Text(item!.repeat.toLocaleString()),
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
                              )),
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

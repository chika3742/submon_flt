import "package:flutter/material.dart";
import "package:flutter_linkify/flutter_linkify.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:google_mobile_ads/google_mobile_ads.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher_string.dart";

import "../components/digestive_detail_card.dart";
import "../components/digestive_edit_bottom_sheet.dart";
import "../components/submissions/formatted_date_remaining.dart";
import "../isar_db/isar_digestive.dart";
import "../isar_db/isar_submission.dart";
import "../main.dart";
import "../providers/digestive_providers.dart";
import "../providers/firebase_providers.dart";
import "../providers/submission_providers.dart";
import "../utils/ad_unit_ids.dart";
import "../utils/ui.dart";
import "submission_edit_page.dart";

class SubmissionDetailPage extends ConsumerStatefulWidget {
  const SubmissionDetailPage(this.submissionId, {super.key});

  static const routeName = "/submission/detail";

  final int submissionId;

  @override
  ConsumerState<SubmissionDetailPage> createState() =>
      _SubmissionDetailPageState();
}

enum SubmissionDetailPagePopAction { delete }

class SubmissionDetailPageArguments {
  final int submissionId;

  SubmissionDetailPageArguments(this.submissionId);
}

class _SubmissionDetailPageState extends ConsumerState<SubmissionDetailPage> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();

    if (!screenShotMode && ref.read(isAdEnabledProvider)) {
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
    final asyncItem = ref.watch(submissionProvider(widget.submissionId));
    final asyncDigestive = ref.watch(digestivesBySubmissionProvider(widget.submissionId));


    return switch ((asyncItem, asyncDigestive)) {
      (AsyncLoading(), _) || (_, AsyncLoading()) => Scaffold(
          appBar: AppBar(),
          body: const Center(child: CircularProgressIndicator()),
        ),
      (AsyncError(:final error), _) || (_, AsyncError(:final error)) => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text("エラーが発生しました: $error")),
        ),
      (AsyncData(value: final item?), AsyncData(value: final digestiveList)) =>
        _buildContent(item, digestiveList),
      _ => Scaffold(
          appBar: AppBar(),
          body: const Center(child: Text("提出物が見つかりません")),
        ),
    };
  }

  Widget _buildContent(Submission item, List<Digestive> digestiveList) {
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
              item.important == true ? Icons.star : Icons.star_outline,
              color: item.important == true ? Colors.yellowAccent : null,
            ),
            onPressed: () {
              final repo = ref.read(submissionRepositoryProvider);
              repo.toggleImportant(item);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                SubmissionEditPage.routeName,
                arguments: SubmissionEditPageArguments(widget.submissionId),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding:
        EdgeInsets.only(bottom: _bannerAd?.size.height.toDouble() ?? 0.0),
        child: FloatingActionButton(
          onPressed: _showCreateDigestiveBottomSheet,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(thickness: 2, indent: 32, endIndent: 32),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Spacer(),
                            const Icon(Icons.event_available),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat("M/d (E)", "ja_JP")
                                  .format(item.due),
                              style: const TextStyle(fontSize: 18),
                            ),
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
                            FormattedDateRemaining(
                              item.due.difference(DateTime.now()),
                              numberSize: 24,
                            ),
                          ],
                        ),
                      ),
                      if (item.repeat != Repeat.none)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Spacer(),
                              const Icon(Icons.repeat),
                              const SizedBox(width: 8),
                              Text(item.repeat.toLocaleString()),
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          right: 16.0,
                          bottom: 16.0,
                        ),
                        child: Linkify(
                          onOpen: (link) async {
                            if (await canLaunchUrlString(link.url)) {
                              await launchUrlString(
                                link.url,
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              throw "Could not launch $link";
                            }
                          },
                          text: item.details,
                          style: const TextStyle(fontSize: 16, height: 1.7),
                        ),
                      ),
                      const Divider(thickness: 2, indent: 32, endIndent: 32),
                      const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Digestive",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ...digestiveList.map(
                            (e) => DigestiveDetailCard(
                          digestive: e,
                        ),
                      ),
                      if (digestiveList.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Opacity(
                              opacity: 0.7,
                              child: Text(
                                "Digestiveがありません。右下の「+」から\n追加できます。",
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

  Future<void> _showCreateDigestiveBottomSheet() async {
    final data = await showRoundedBottomSheet<Digestive>(
      context: context,
      title: "Digestive 新規作成",
      child: DigestiveEditBottomSheet(submissionId: widget.submissionId),
    );
    if (data != null) {
      final repo = ref.read(digestiveRepositoryProvider);
      await repo.create(data);
    }
  }
}

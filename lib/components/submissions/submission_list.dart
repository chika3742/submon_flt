import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:submon/components/submissions/submission_list_item.dart';
import 'package:submon/db/shared_prefs.dart';
import 'package:submon/events.dart';
import 'package:submon/isar_db/isar_digestive.dart';
import 'package:submon/isar_db/isar_submission.dart';
import 'package:submon/main.dart';
import 'package:submon/utils/ui.dart';
import 'package:submon/utils/utils.dart';

import '../../sample_data.dart';

class SubmissionList extends StatefulWidget {
  const SubmissionList({Key? key, this.done = false}) : super(key: key);

  final bool done;

  @override
  SubmissionListState createState() => SubmissionListState();
}

class SubmissionListState extends State<SubmissionList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<Submission>? items;

  StreamSubscription? _stream1;
  StreamSubscription? _stream2;

  final AudioCache _audioCache = AudioCache();
  SharedPrefs? _prefs;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SubmissionProvider().use((provider) async {
      if (screenShotMode) {
        items = SampleData.submissions;
      } else if (!widget.done) {
        items = await provider.getUndoneSubmissions();
      } else {
        items = await provider.getDoneSubmissions();
      }

      setState(() {
        items?.asMap().forEach((index, element) async {
          _listKey.currentState?.insertItem(index, duration: const Duration());
        });
      });
    });

    _stream1 = eventBus.on<BottomNavDoubleClickEvent>().listen((event) {
      if (event.index == 0) {
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutQuint);
      }
    });

    _stream2 = eventBus.on<SubmissionInserted>().listen((event) {
      SubmissionProvider().use((provider) async {
        var data = await provider.get(event.id);

        if (data != null) {
          setState(() {
            items!.add(data);
          });
          _listKey.currentState?.insertItem(items!.length - 1);
          await Future.delayed(const Duration(milliseconds: 300));
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutQuint);
        }
      });
    });

    SharedPrefs.use((prefs) {
      _listKey.currentState?.setState(() {
        _prefs = prefs;
      });
    });

    _audioCache.load("audio/decision28.mp3");
  }

  @override
  void dispose() {
    super.dispose();
    _stream1?.cancel();
    _stream2?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (items != null)
          AnimatedOpacity(
            opacity: items!.isNotEmpty ? 0 : 0.7,
            duration: const Duration(milliseconds: 200),
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("提出物がありません", style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        Scrollbar(
          controller: _scrollController,
          child: AnimatedList(
            key: _listKey,
            controller: _scrollController,
            itemBuilder: (context, pos, anim) {
              return _buildSubmissionItem(anim, pos);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmissionItem(Animation anim, int pos) {
    return SizeTransition(
      sizeFactor: anim.drive(Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutQuint))),
      child: SubmissionListItem(items![pos], key: ObjectKey(items![pos].id),
          onDelete: (animated) {
        delete(pos, animated);
      }, onDone: (animated) {
        checkDone(pos, animated);
      }, prefs: _prefs),
    );
  }

  Widget _buildRemovedSubmissionItem(Animation anim, Submission item) {
    return SizeTransition(
      sizeFactor: anim.drive(Tween(begin: 0.0, end: 1.0)
          .chain(CurveTween(curve: Curves.easeOutQuint.flipped))),
      child: SubmissionListItem(item, key: ObjectKey(item.id), prefs: _prefs),
    );
  }

  void checkDone(int index, bool animated) {
    var item = items![index];
    setState(() {
      _listKey.currentState?.removeItem(index,
          (context, animation) => _buildRemovedSubmissionItem(animation, item),
          duration: Duration(milliseconds: animated ? 300 : 0));
      items!.removeWhere((element) => element.id == item.id);
    });

    SubmissionProvider().use((provider) {
      return provider.writeTransaction(() async {
        await provider.invertDone(item);
      });
    });

    if (!widget.done && _prefs?.isSEEnabled == true) {
      _audioCache.play("audio/decision28.mp3");
    }

    showSnackBar(context, !widget.done ? "完了にしました" : "完了を外しました",
        action: SnackBarAction(
          label: "元に戻す",
          textColor: Colors.pinkAccent,
          onPressed: () {
            SubmissionProvider().use((provider) {
              return provider.writeTransaction(() async {
                provider.invertDone(item);
              });
            });
            try {
              setState(() {
                var actualIndex =
                    items!.length <= index ? items!.length : index;
                items!.insert(actualIndex, item);
                _listKey.currentState?.insertItem(actualIndex);
              });
            } catch (e, st) {
              recordErrorToCrashlytics(e, st);
            }
          },
        ));
  }

  void delete(int index, bool animated) async {
    var submission = items![index];

    SubmissionProvider().use((provider) async {
      SubmissionProvider.deleteFromGoogleTasks(submission.googleTasksTaskId);
      if (await provider.get(submission.id!) != null) {
        await provider.deleteItem(submission.id!);
      }
    });

    late List<Digestive> digestivesToRestore;
    await DigestiveProvider().use((provider) async {
      digestivesToRestore =
          await provider.getDigestivesBySubmissionId(submission.id!);
    });

    try {
      setState(() {
        items!.removeAt(index);
        _listKey.currentState?.removeItem(
            index,
            (context, animation) =>
                _buildRemovedSubmissionItem(animation, submission),
            duration: Duration(milliseconds: animated ? 300 : 0));
      });

      showSnackBar(globalContext!, "削除しました",
          action: SnackBarAction(
            label: "元に戻す",
            textColor: Colors.pinkAccent,
            onPressed: () async {
              await SubmissionProvider().use((provider) async {
                await provider.writeTransaction(() async {
                  await provider.put(submission);
                });
              });

              DigestiveProvider().use((provider) async {
                provider.writeTransaction(() async {
                  for (var digestive in digestivesToRestore) {
                    await provider.put(digestive);
                  }
                });
              });

              setState(() {
                var actualIndex =
                    items!.length <= index ? items!.length : index;
                items!.insert(actualIndex, submission);
                _listKey.currentState?.insertItem(actualIndex);
              });
            },
          ));
    } catch (e, st) {
      recordErrorToCrashlytics(e, st);
      showSnackBar(context, "エラーが発生しました");
    }
  }
}

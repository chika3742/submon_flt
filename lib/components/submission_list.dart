import 'package:flutter/material.dart';
import 'package:submon/components/submission_list_item.dart';
import 'package:submon/events.dart';
import 'package:submon/local_db/submission.dart';

class SubmissionList extends StatefulWidget {
  const SubmissionList({Key? key, this.initialItems = const []}) : super(key: key);

  final List<Submission> initialItems;

  @override
  _SubmissionListState createState() => _SubmissionListState();
}

class _SubmissionListState extends State<SubmissionList> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  late List<Submission> items;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SubmissionProvider.use((provider) async {
      var data = Submission();
      data.title = "Tasdaditle";
      // await provider.insert(data);
      items = await provider.getSubmissions([colId, colDate, colTitle, colColor, colDone]);
      items.asMap().forEach((index, element) async {
        _listKey.currentState?.insertItem(index, duration: const Duration());
      });
    });

    eventBus.on<BottomNavDoubleClickEvent>().listen((event) {
      if (event.index == 0) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuint);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      controller: _scrollController,
      itemBuilder: (context, pos, anim) {
        return SubmissionListItem(items[pos]);
      },
    );
  }
}

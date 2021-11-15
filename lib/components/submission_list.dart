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
  final _dataCols = [colId, colDate, colTitle, colColor, colDone];

  @override
  void initState() {
    super.initState();

    SubmissionProvider.use((provider) async {
      items = await provider.getSubmissions(_dataCols);
      items.asMap().forEach((index, element) async {
        _listKey.currentState?.insertItem(index, duration: const Duration());
      });
    });

    eventBus.on<BottomNavDoubleClickEvent>().listen((event) {
      if (event.index == 0) {
        _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuint);
      }
    });

    eventBus.on<SubmissionInserted>().listen((event) {
      var prov = SubmissionProvider();
      prov.open().then((value) {
        return prov.getSubmission(event.id, _dataCols);
      }).then((data) {
        prov.close();
        if (data != null) {
          items.add(data);
          _listKey.currentState?.insertItem(items.length - 1);
        }
      });
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

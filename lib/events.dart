import 'package:event_bus/event_bus.dart';

// final eventBus = EventBus();

class BottomNavDoubleClickEvent {
  int index;
  BottomNavDoubleClickEvent(this.index);
}

class SubmissionInserted {
  int id;
  SubmissionInserted(this.id);
}
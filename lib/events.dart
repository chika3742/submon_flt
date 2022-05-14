import 'package:event_bus/event_bus.dart';
import 'package:submon/pages/home_page.dart';

final eventBus = EventBus();

class BottomNavDoubleClickEvent {
  int index;

  BottomNavDoubleClickEvent(this.index);
}

class SubmissionInserted {
  int id;

  SubmissionInserted(this.id);
}

class UndoRedoUpdatedEvent {
  UndoRedoUpdatedEvent();
}

class SubmissionFetched {
  SubmissionFetched();
}

class TimetableListChanged {}

class MemorizeCardAddButtonPressed {}

class DigestiveAddButtonPressed {}

class SetAdHidden {
  bool hidden;

  SetAdHidden(this.hidden);
}

class SwitchBottomNav {
  BottomNavItemId id;

  SwitchBottomNav(this.id);
}

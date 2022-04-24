import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();

class SignedInWithLink {}

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

class SubmissionDetailPageOpened {
  bool opened;

  SubmissionDetailPageOpened(this.opened);
}
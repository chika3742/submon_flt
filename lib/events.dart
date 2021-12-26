import 'package:event_bus/event_bus.dart';
import 'package:submon/db/timetable_custom_subject.dart';

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

class TimetableCustomSubjectInserted {
  TimetableCustomSubject data;

  TimetableCustomSubjectInserted(this.data);
}

class MemorizeCardAddButtonPressed {
  MemorizeCardAddButtonPressed();
}
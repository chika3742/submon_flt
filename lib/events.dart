import "package:event_bus/event_bus.dart";

final eventBus = EventBus();

class BottomNavDoubleClickEvent {
  int index;

  BottomNavDoubleClickEvent(this.index);
}

class UndoRedoUpdatedEvent {
  UndoRedoUpdatedEvent();
}

class TimetableListChanged {}

class MemorizeCardAddButtonPressed {}

class DigestiveAddButtonPressed {}

class SetAdHidden {
  bool hidden;

  SetAdHidden(this.hidden);
}

class SwitchBottomNav {
  String path;

  SwitchBottomNav(this.path);
}

class OnDigestiveDoneChanged {
  int digestiveId;
  bool done;

  OnDigestiveDoneChanged(this.digestiveId, this.done);
}

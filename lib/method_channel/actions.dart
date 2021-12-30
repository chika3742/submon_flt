import 'package:flutter/services.dart';
import 'package:submon/method_channel/channels.dart';

class PendingAction {
  String actionName;
  int? argument;

  PendingAction(this.actionName, this.argument);
}

Future<PendingAction?> getPendingAction() async {
  const mc = MethodChannel(Channels.actions);

  final action = await mc.invokeMethod<String>("getPendingAction");
  final argument = await mc.invokeMethod<int>("getPendingActionArgument");

  if (action == null) return null;
  return PendingAction(action, argument);
}

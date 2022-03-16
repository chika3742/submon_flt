import 'package:flutter/services.dart';
import 'package:submon/method_channel/channels.dart';

class PendingAction {
  String actionName;
  Map<String, dynamic>? arguments;

  PendingAction(this.actionName, this.arguments);
}

Future<PendingAction?> getPendingAction() async {
  const mc = MethodChannel(Channels.action);

  var action = (await mc.invokeMethod("getPendingAction"));

  if (action == null) return null;
  action = Map.from(action);
  var arguments = action["arguments"];
  return PendingAction(
      action["actionName"], arguments != null ? Map.from(arguments) : null);
}

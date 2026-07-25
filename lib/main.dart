import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "features/auth/infrastructure/services/sign_in_state.dart";
import "routing/router_provider.dart";
import "submon_app.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(ProviderScope(
    overrides: [
      initialSignInStateProvider.overrideWithValue(await signInState()),
    ],
    child: SubmonApp(),
  ));
}

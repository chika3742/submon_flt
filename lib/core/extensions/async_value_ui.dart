import "package:flutter/material.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../utils/ui.dart";

extension AsyncValueUI on AsyncValue<void> {
  void showSnackBarOnError(BuildContext context, String message) => whenOrNull(
    error: (e, _) => showSnackBar(context, message),
  );

  void showLoadingModalDuringLoading(BuildContext context) => switch (this) {
        AsyncLoading() => showLoadingModal(context),
        _ => closeLoadingModal(context),
      };
}

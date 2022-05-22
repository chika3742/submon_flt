import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AdUnit {
  homeBottomBanner,
  submissionDetailBanner,
  focusTimerInterstitial,
}

class AdUnits {
  // Debug
  static const _adUnitDebugBanner = "AD_UNIT_DEBUG_BANNER";
  static const _adUnitDebugInterstitial = "AD_UNIT_DEBUG_INTERSTITIAL";

  // Release
  static const _adUnitHome = "AD_UNIT_HOME";
  static const _adUnitSubmissionDetail = "AD_UNIT_SUBMISSION_DETAIL";
  static const _adUnitFocusTimerInterstitial =
      "AD_UNIT_FOCUS_TIMER_INTERSTITIAL";

  AdUnits._();

  static String? get homeBottomBanner {
    return _getAdUnitId(
      releaseAdUnitName: _adUnitHome,
      debugAdUnitName: _adUnitDebugBanner,
    );
  }

  static String? get submissionDetailBanner {
    return _getAdUnitId(
      releaseAdUnitName: _adUnitSubmissionDetail,
      debugAdUnitName: _adUnitDebugBanner,
    );
  }

  static String? get focusTimerInterstitial {
    return _getAdUnitId(
      releaseAdUnitName: _adUnitFocusTimerInterstitial,
      debugAdUnitName: _adUnitDebugInterstitial,
    );
  }

  static String? _getAdUnitIdForPlatform(String unitName) {
    if (Platform.isIOS) {
      return dotenv.get("${unitName}_IOS");
    } else if (Platform.isAndroid) {
      return dotenv.get("${unitName}_ANDROID");
    }
    return null;
  }

  static String _getAdUnitId(
      {required String releaseAdUnitName, required String debugAdUnitName}) {
    if (kReleaseMode) {
      return _getAdUnitIdForPlatform(releaseAdUnitName)!;
    } else {
      return _getAdUnitIdForPlatform(debugAdUnitName)!;
    }
  }
}

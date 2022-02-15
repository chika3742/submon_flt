import 'package:submon/pages/memorize/camera_preview_page.dart';
import 'package:submon/utils/text_recognized_candidate_painter.dart';

class CardSideBuilder {
  Set<TextElement> front = {};
  Set<TextElement> back = {};

  void append(CardSide side, TextElement fragment) {
    if (side == CardSide.front) {
      front.add(fragment);
    } else {
      back.add(fragment);
    }
  }

  Set<TextElement> get(CardSide side) {
    if (side == CardSide.front) {
      return front;
    } else {
      return back;
    }
  }

  void clear(CardSide side) {
    if (side == CardSide.front) {
      front.clear();
    } else {
      back.clear();
    }
  }

  void clearAll() {
    front.clear();
    back.clear();
  }

  String toStringFront() {
    return front.map((e) => e.text).join();
  }

  String toStringBack() {
    return back.map((e) => e.text).join();
  }
}

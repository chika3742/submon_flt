import 'package:flutter/material.dart';
import 'package:submon/pages/memorize/camera_preview_page.dart';

class CardSideBuilder {
  List<WordFragment> front = [];
  List<WordFragment> back = [];

  void append(CardSide side, WordFragment fragment) {
    if (side == CardSide.front) {
      front.add(fragment);
    } else {
      back.add(fragment);
    }
  }

  void clear(CardSide side) {
    if (side == CardSide.front) {
      front.clear();
    } else {
      back.clear();
    }
  }

  String toStringFront() {
    return front.map((e) => e.text).join();
  }

  String toStringBack() {
    return back.map((e) => e.text).join();
  }
}

class WordFragment {
  RRect? vertices;
  String text;

  WordFragment(this.text, {this.vertices});
}

class Space extends WordFragment {
  Space() : super(" ");
}

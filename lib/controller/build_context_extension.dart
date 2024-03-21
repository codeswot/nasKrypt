import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  pushRoute(Widget widget) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  popRoute() {
    return Navigator.of(this).pop();
  }
}

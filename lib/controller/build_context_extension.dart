import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  pushRoute(Widget widget) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  pushRouteUntil(Widget widget, bool Function(Route<dynamic>) predicate) {
    Navigator.of(this).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      predicate,
    );
  }

  pushReplacementRoute(Widget widget) {
    Navigator.of(this).pushReplacement(
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  popRoute() {
    return Navigator.of(this).pop();
  }

  showAppDilog(String title, String message, List<Widget> actions) {
    return showDialog(
      context: this,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
      },
    );
  }
}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  String get toYearString => year.toString();
}

extension IntExtension on int {
  String toDurationString() {
    Duration duration = Duration(milliseconds: this);

    if (duration.inDays >= 30) {
      return '${duration.inDays ~/ 30} months';
    } else if (duration.inDays >= 7) {
      return '${duration.inDays ~/ 7} weeks';
    } else if (duration.inDays > 0) {
      return '${duration.inDays} days';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hours';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutes';
    } else if (duration.inSeconds > 0) {
      return '${duration.inSeconds} seconds';
    } else {
      return '${duration.inMilliseconds} milliseconds';
    }
  }
}

extension DurationExtension on Duration {
  int get toDurationInDayOrWeek {
    if (inDays >= 30) {
      return inDays ~/ 30;
    } else if (inDays >= 7) {
      return inDays ~/ 7;
    } else {
      return inDays;
    }
  }
}

extension StringToDuration on String {
  Duration toDaysOrWeeksDuration() {
    final parts = split(' '); // Split the string into parts
    if (parts.length != 2) {
      throw const FormatException('Invalid format');
    }

    final value = int.tryParse(parts[0]);
    final unit = parts[1].toLowerCase();

    if (value == null) {
      throw const FormatException('Invalid number');
    }

    if (unit == 'weeks' || unit == 'week') {
      return Duration(days: value * 7); // Convert weeks to days
    } else if (unit == 'days' || unit == 'day') {
      return Duration(days: value); // Use days directly
    } else {
      throw const FormatException('Invalid unit');
    }
  }
}

extension FileNameExtension on String {
  String get toVisualFileName {
    String fileName = split('/').last;

    if (fileName.length > 20) {
      int dotIndex = fileName.lastIndexOf('.');
      if (dotIndex != -1) {
        String namePart = fileName.substring(0, dotIndex);
        String extensionPart = fileName.substring(dotIndex);

        int charsToShow = 10;
        String start = namePart.substring(0, charsToShow);
        String end = namePart.substring(namePart.length - charsToShow);

        fileName = '$start...$end$extensionPart';
      }
    }
    return fileName;
  }
}

extension StringExtension on String {
  String toSentenceCase() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}

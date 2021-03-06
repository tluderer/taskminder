import 'package:flutter/material.dart';

/// date: Database String: YYYYMMDD as String
/// date: Readable String: DD.MM.YYYY as String
/// date: DateTime Object
///
/// time: DatabaseString: HHMM as String
/// time: ReadableString: HH:MM as String
/// time: TimeOfDay Object
///

class DateTimeHelper {
  String makeDatabaseString(int day, int month, int year) {
    return year.toString() +
        month.toString().padLeft(2, "0") +
        day.toString().padLeft(2, "0");
  }

  String dateToReadableString(DateTime datetime) {
    return datetime.day.toString().padLeft(2, "0") +
        "." +
        datetime.month.toString().padLeft(2, "0") +
        "." +
        datetime.year.toString();
  }

  String dateToDatabaseString(DateTime datetime) {
    return datetime.year.toString() +
        datetime.month.toString().padLeft(2, "0") +
        datetime.day.toString().padLeft(2, "0");
  }

  String databaseDateStringToReadable(String databaseString) {
    return databaseString.substring(6, 8) +
        "." +
        databaseString.substring(4, 6) +
        "." +
        databaseString.substring(0, 4);
  }

  String timeToReadableString(TimeOfDay _time) {
    return _time.hour.toString().padLeft(2, "0") +
        ":" +
        _time.minute.toString().padLeft(2, "0");
  }

  String timeToDatabaseString(TimeOfDay _time) {
    return _time.hour.toString().padLeft(2, "0") +
        _time.minute.toString().padLeft(2, "0");
  }

  String databaseTimeStringToReadable(String databaseString) {
    return databaseString.substring(0, 2) +
        ":" +
        databaseString.substring(2, 4);
  }

  int calculateDateTimeDifference(
    DateTime dtEarly,
    DateTime dtLater, {
    bool inDays,
    bool inHours,
    bool inWeeks,
  }) {
    if (inHours == null) inHours = false;
    if (inDays == null) inDays = false;

    if (inWeeks == null) inWeeks = false;

    if (inDays == false && inHours == false && inWeeks == false) {
      throw new Exception();
    }

    if ((inDays ? 1 : 0) + (inHours ? 1 : 0) + (inWeeks ? 1 : 0) > 1) {
      throw new Exception();
    }

    Duration difference = dtLater.difference(dtEarly);
    if (inDays == true) {
      return difference.inDays;
    }
    if (inHours == true) {
      return difference.inHours;
    }
    if (inWeeks == true) {
      return ((difference.inDays) / 7).round();
    }

    return 0;
  }
}

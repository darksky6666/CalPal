// date_logic.dart

import 'package:intl/intl.dart';

class DateLogic {
  DateTime currentDate;

  DateLogic() : currentDate = DateTime.now() {
    _setInitialDate();
  }

  void _setInitialDate() {
    currentDate =
        DateTime(currentDate.year, currentDate.month, currentDate.day);
  }

  void navigateToPreviousDay() {
    currentDate = currentDate.subtract(Duration(days: 1));
  }

  void navigateToNextDay() {
    currentDate = currentDate.add(Duration(days: 1));
  }

  DateTime getCurrentDate() {
    return currentDate;
  }

  String getFormattedDate([DateTime? date]) {
    DateTime selectedDate = date ?? currentDate;
    return DateFormat('yyyyMMdd').format(selectedDate);
  }

  DateTime getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  void navigateToPreviousWeek() {
    currentDate = getStartOfWeek(currentDate).subtract(Duration(days: 7));
  }

  void navigateToNextWeek() {
    currentDate = getStartOfWeek(currentDate).add(Duration(days: 7));
  }

  int getWeekNumber(DateTime date) {
    int dayOfYear = int.parse(DateFormat("D").format(date));
    int startWeekday = DateTime(date.year, 1, 1).weekday;
    int weekNumber = ((dayOfYear - startWeekday + 10) ~/ 7);
    return weekNumber;
  }
}

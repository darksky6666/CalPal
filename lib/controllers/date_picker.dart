// date_logic.dart

import 'package:intl/intl.dart';

class DateLogic {
  DateTime currentDate;

  DateLogic() : currentDate = DateTime.now() {
    _setInitialDate();
  }

  void _setInitialDate() {
    currentDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
  }

  void navigateToPreviousDay() {
    currentDate = currentDate.subtract(Duration(days: 1));
  }

  void navigateToNextDay() {
    currentDate = currentDate.add(Duration(days: 1));
  }

  String getCurrentDate() {
    String formattedDate = DateFormat('yyyyMMdd').format(currentDate);
    return formattedDate;
  }
}

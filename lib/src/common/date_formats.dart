import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get timeString => DateFormat('HH:mm', 'de_DE').format(this);
  String get timeStringWithSeconds =>
      DateFormat('HH:mm:ss', 'de_DE').format(this);

  String get dateString => DateFormat('dd.MM.yyyy', 'de_DE').format(this);
  String get shortDateString => DateFormat('dd.MM.yy', 'de_DE').format(this);

  String get midDateString => DateFormat('dd. MMM yyyy', 'de_DE').format(this);
  String get longDateString =>
      DateFormat('EEEE, dd. MMMM yyyy', 'de_DE').format(this);

  String get dateTimeString =>
      DateFormat('dd.MM.yyyy HH:mm', 'de_DE').format(this);
  String get longDateTimeString =>
      DateFormat('EEEE, dd. MMMM yyyy, HH:mm', 'de_DE').format(this);

  String get dayName => DateFormat('EEEE', 'de_DE').format(this);
  String get monthName => DateFormat('MMMM', 'de_DE').format(this);
  String get shortMonthName => DateFormat('MMM', 'de_DE').format(this);
}

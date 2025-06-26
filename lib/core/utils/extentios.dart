import 'package:easy_localization/easy_localization.dart';

extension DateRangeExtension on DateTime {
  String yesterdayToTodayRange() {
    final today = DateTime(year, month, day);
    final yesterday = today.subtract(const Duration(days: 1));
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    return '${formatter.format(yesterday)} - ${formatter.format(today)}';
  }
}
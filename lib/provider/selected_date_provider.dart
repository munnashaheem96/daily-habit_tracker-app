import 'package:flutter/material.dart';

class SelectedDate extends ChangeNotifier {
  DateTime _date = DateTime.now();

  DateTime get date => _date;

  void setDate(DateTime newDate) {
    _date = newDate;
    notifyListeners();
  }

  String get key =>
      "${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}";
}

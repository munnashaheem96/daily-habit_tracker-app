import 'package:flutter/material.dart';

class SelectedDate extends ValueNotifier<DateTime> {
  SelectedDate() : super(DateTime.now());

  void update(DateTime date) {
    value = date;
  }
}

final selectedDateNotifier = SelectedDate();

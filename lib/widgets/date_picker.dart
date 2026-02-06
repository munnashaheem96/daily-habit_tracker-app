import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerRow extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  DatePickerRow({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime today = DateTime.now();

  List<DateTime> get dates => List.generate(
        7,
        (i) => DateTime(today.year, today.month, today.day - 3 + i),
      );

  bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool isFuture(DateTime date) =>
      date.isAfter(DateTime(today.year, today.month, today.day));

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];

          final bool isToday = isSameDay(date, today);
          final bool isPast =
              date.isBefore(DateTime(today.year, today.month, today.day));
          final bool future = isFuture(date);

          Color bgColor;
          Color textColor;

          if (future) {
            bgColor = const Color(0xFFF2F2F2);
            textColor = Colors.black26;
          } else if (isToday) {
            bgColor = Colors.black;
            textColor = Colors.white;
          } else if (isPast) {
            bgColor = const Color(0xFFB8F068);
            textColor = Colors.black;
          } else {
            bgColor = const Color(0xFFF2F2F2);
            textColor = Colors.black54;
          }

          return GestureDetector(
            onTap: future ? null : () => onDateSelected(date),
            child: Opacity(
              opacity: future ? 0.5 : 1,
              child: Container(
                width: 54,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('dd').format(date),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEE').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: textColor.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

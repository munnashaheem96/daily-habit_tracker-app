import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgressOverviewScreen extends StatefulWidget {
  const ProgressOverviewScreen({super.key});

  @override
  State<ProgressOverviewScreen> createState() =>
      _ProgressOverviewScreenState();
}

class _ProgressOverviewScreenState extends State<ProgressOverviewScreen> {
  final DateTime today = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  late DateTime currentMonth;

  @override
  void initState() {
    super.initState();
    currentMonth = DateTime(today.year, today.month);
  }

  bool get isCurrentMonth =>
      currentMonth.year == today.year &&
      currentMonth.month == today.month;

  String dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final DateTime monthStart =
        DateTime(currentMonth.year, currentMonth.month, 1);
    final int daysInMonth =
        DateUtils.getDaysInMonth(currentMonth.year, currentMonth.month);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('daily_records')
              .snapshots(),
          builder: (context, snapshot) {
            final docs = snapshot.data?.docs ?? [];

            final Set<String> doneDays = {};
            int monthlyDoneDays = 0;

            for (final doc in docs) {
              final date = DateTime.tryParse(doc.id);
              if (date == null) continue;

              final habits =
                  (doc['habits'] ?? {}) as Map<String, dynamic>;

              if (habits.isNotEmpty &&
                  date.year == currentMonth.year &&
                  date.month == currentMonth.month) {
                doneDays.add(doc.id);
                monthlyDoneDays++;
              }
            }

            final double monthlyPercent =
                daysInMonth == 0 ? 0 : monthlyDoneDays / daysInMonth;

            /// Monday-based offset (Mon = 1, Sun = 7)
            final int firstWeekdayOffset =
                (monthStart.weekday + 6) % 7;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔹 CUSTOM APP BAR
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Progress Overview',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 🔹 MONTH HEADER
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            currentMonth = DateTime(
                              currentMonth.year,
                              currentMonth.month - 1,
                            );
                          });
                        },
                        child: const Text(
                          '< Last month',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Text(
                        DateFormat('MMMM yyyy')
                            .format(currentMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      GestureDetector(
                        onTap: isCurrentMonth
                            ? null
                            : () {
                                setState(() {
                                  currentMonth = DateTime(
                                    currentMonth.year,
                                    currentMonth.month + 1,
                                  );
                                });
                              },
                        child: Text(
                          'Next month >',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isCurrentMonth
                                ? Colors.black26
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔹 WEEKDAY HEADER (MONDAY FIRST)
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: const [
                      _WeekDay('M'),
                      _WeekDay('T'),
                      _WeekDay('W'),
                      _WeekDay('T'),
                      _WeekDay('F'),
                      _WeekDay('S'),
                      _WeekDay('S'),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // 🔹 CALENDAR GRID
                  GridView.builder(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount:
                        firstWeekdayOffset + daysInMonth,
                    itemBuilder: (_, index) {
                      if (index < firstWeekdayOffset) {
                        return const SizedBox();
                      }

                      final int day =
                          index - firstWeekdayOffset + 1;
                      final date = DateTime(
                        currentMonth.year,
                        currentMonth.month,
                        day,
                      );

                      final bool isDone =
                          doneDays.contains(dateKey(date));
                      final bool isFuture =
                          date.isAfter(today);

                      return Container(
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFFB8F068)
                              : isFuture
                                  ? Colors.grey.shade200
                                  : Colors.grey.shade100,
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '$day',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isFuture
                                  ? Colors.black26
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // 🔹 MONTHLY PERCENTAGE CARD
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB8F068),
                          Color(0xFFA3E635),
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMMM')
                              .format(currentMonth),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${(monthlyPercent * 100).toInt()}% completed',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: monthlyPercent,
                            minHeight: 10,
                            backgroundColor: Colors.white
                                .withOpacity(0.4),
                            valueColor:
                                const AlwaysStoppedAnimation(
                              Color(0xff4e55e0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // 🔹 PAST 5 + TODAY + FUTURE 1 (CURRENT MONTH ONLY)
                  if (isCurrentMonth)
                    ...List.generate(7, (index) {
                      final date =
                          today.subtract(Duration(days: 5 - index));
                      final bool isFuture =
                          date.isAfter(today);
                      final bool isDone =
                          doneDays.contains(dateKey(date));

                      return Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(18),
                          color: isFuture
                              ? Colors.grey.shade200
                              : isDone
                                  ? const Color(0xFFB8F068)
                                  : Colors.grey.shade100,
                        ),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('EEE')
                                      .format(date),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('d MMM')
                                      .format(date),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              isFuture
                                  ? 'Future'
                                  : isDone
                                      ? 'Completed'
                                      : 'Missed',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isFuture
                                    ? Colors.black38
                                    : isDone
                                        ? Colors.black
                                        : Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// WEEKDAY LABEL WIDGET
class _WeekDay extends StatelessWidget {
  final String label;
  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}

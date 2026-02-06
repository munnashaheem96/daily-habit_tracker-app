import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_habit_app/screens/progress_overview_screen.dart';
import 'package:daily_habit_app/widgets/add_habit_popup.dart';
import 'package:daily_habit_app/widgets/date_picker.dart';
import 'package:daily_habit_app/widgets/show_habit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  String get dateKey =>
      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

  String get formattedSelectedDate {
    final today = DateTime.now();
    if (DateUtils.isSameDay(selectedDate, today)) {
      return 'Today';
    }
    return DateFormat('EEE, d MMM').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            /// MAIN CONTENT
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('habits')
                  .snapshots(),
              builder: (context, habitSnapshot) {
                if (!habitSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final habits = habitSnapshot.data!.docs;

                return StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('daily_records')
                      .doc(dateKey)
                      .snapshots(),
                  builder: (context, daySnapshot) {
                    final data =
                        daySnapshot.data?.data() as Map<String, dynamic>?;

                    final Map<String, dynamic> dayHabits =
                        (data?['habits'] ?? {});

                    final int doneCount = dayHabits.length;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Good Morning,',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w200,
                                      height: 1.0,
                                    ),
                                  ),
                                  Text(
                                    'Munna Shaheem',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              FaIcon(FontAwesomeIcons.bell),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // DATE PICKER
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: DatePickerRow(
                            selectedDate: selectedDate,
                            onDateSelected: (date) {
                              setState(() => selectedDate = date);
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // PROGRESS CARD
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProgressOverviewScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Container(
                              width: double.infinity,
                              height: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFB8F068),
                                    Color(0xFFA3E635),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(18),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            formattedSelectedDate,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            '$doneCount of ${habits.length} habits done',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                            child: LinearProgressIndicator(
                                              value: habits.isEmpty
                                                  ? 0.0
                                                  : doneCount / habits.length,
                                              minHeight: 8,
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
                                    const SizedBox(width: 16),
                                    Container(
                                      width: 64,
                                      height: 64,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.35),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Text(
                                          habits.isEmpty
                                              ? '0%'
                                              : '${((doneCount / habits.length) * 100).toInt()}%',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // HABITS GRID
                        SizedBox(
                          height: 444,
                          child: GridView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                  mainAxisExtent: 250,
                                ),
                            itemCount: habits.length,
                            itemBuilder: (context, index) {
                              final habit = habits[index];
                              final bool isDone = dayHabits.containsKey(
                                habit.id,
                              );

                              return ShowHabit(
                                habitDoc: habit,
                                dateKey: dateKey,
                                isDone: isDone,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            /// BOTTOM NAV
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(CupertinoIcons.house_fill, size: 28),
                    const SizedBox(width: 25),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const AddHabitPopup(),
                        );
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color(0xFFB8F068),
                      child: FaIcon(FontAwesomeIcons.user, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

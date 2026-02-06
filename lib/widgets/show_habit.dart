import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowHabit extends StatelessWidget {
  final QueryDocumentSnapshot habitDoc;
  final String dateKey;
  final bool isDone;

  const ShowHabit({
    super.key,
    required this.habitDoc,
    required this.dateKey,
    required this.isDone,
  });

  Future<void> toggleStatus() async {
    final ref = FirebaseFirestore.instance
        .collection('daily_records')
        .doc(dateKey);

    if (isDone) {
      await ref.update({
        'habits.${habitDoc.id}': FieldValue.delete(),
      });
    } else {
      await ref.set({
        'date': dateKey,
        'habits': {
          habitDoc.id: true,
        }
      }, SetOptions(merge: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleStatus,
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: isDone ? Colors.grey[200] : Color(habitDoc['iconColor']),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: FaIcon(
                IconData(
                  habitDoc['iconCode'],
                  fontFamily: habitDoc['iconFont'],
                  fontPackage: habitDoc['iconPackage'],
                ),
                size: 22,
              ),
            ),

            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isDone ? Colors.black : Colors.transparent,
                  border:
                      Border.all(color: Colors.black, width: 2),
                ),
              ),
            ),

            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habitDoc['name'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habitDoc['description'],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        GoogleFonts.nunito(fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

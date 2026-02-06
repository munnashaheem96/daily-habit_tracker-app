import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AddHabitPopup extends StatefulWidget {
  const AddHabitPopup({super.key});

  @override
  State<AddHabitPopup> createState() => _AddHabitPopupState();
}

class _AddHabitPopupState extends State<AddHabitPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  String selectedIntervel = 'Everyday';
  IconData selectedIcon = FontAwesomeIcons.briefcase;
  final List<IconData> habitIcons = [
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.bolt,
    FontAwesomeIcons.user,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.headphones,
    FontAwesomeIcons.shoePrints,
    FontAwesomeIcons.mobileScreen,
    FontAwesomeIcons.house,
    FontAwesomeIcons.road,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.carrot,
    FontAwesomeIcons.calendar,
    FontAwesomeIcons.image,
    FontAwesomeIcons.music,
    FontAwesomeIcons.lightbulb,
  ];
  final List<Color> habitIconColors = [
    Color(0xFFFFD66E), // briefcase
    Color(0xFFFF9ED1), // bolt
    Color(0xFF9EC9FF), // user
    Color(0xFFB8F068), // wallet
    Color(0xFFFFA36C), // utensils
    Color(0xFF9EE7E3), // headphones
    Color(0xFFFFD66E), // shoe
    Color(0xFFFF9ED1), // mobile
    Color(0xFF9EC9FF), // house
    Color(0xFFB8F068), // road
    Color(0xFFFFA36C), // fire
    Color(0xFF9EE7E3), // carrot
    Color(0xFF9EC9FF), // calendar
    Color(0xFFFFD66E), // image
    Color(0xFFFF9ED1), // music
    Color(0xFFB8F068), // lightbulb
  ];

  Future<void> saveHabit() async {
    if (nameController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance.collection('habits').add({
      'name' : nameController.text.trim(),
      'description' : descController.text.trim(),
      'intervel' : selectedIntervel,
      'iconCode' : selectedIcon.codePoint,
      'iconFont' : selectedIcon.fontFamily,
      'iconPackage' : selectedIcon.fontPackage,
      'iconColor' : habitIconColors[habitIcons.indexOf(selectedIcon)].value,
      'createdAt' : Timestamp.now(),
      'status' : 'none',
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200]!.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(FontAwesomeIcons.x, size: 18),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  'Let\' start a new habit',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 15),
            // Form start here
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'Type habit name',
                        hintStyle: GoogleFonts.nunito(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: descController,
                      decoration: InputDecoration(
                        hintText: 'Describe about habit',
                        hintStyle: GoogleFonts.nunito(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Intervals',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey!.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: 'Everyday',
                      items: const [
                        DropdownMenuItem(
                          value: 'Everyday',
                          child: Text('Everyday'),
                        ),
                        DropdownMenuItem(
                          value: 'Weekly',
                          child: Text('Weekly'),
                        ),
                        DropdownMenuItem(
                          value: 'Monthly',
                          child: Text('Monthly'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedIntervel = value!;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Select interval',
                        hintStyle: GoogleFonts.nunito(),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.deepPurpleAccent,
                            width: 1.5,
                          ),
                        ),
                      ),
                      style: GoogleFonts.nunito(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Icon',
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                        ),
                    itemCount: habitIcons.length,
                    itemBuilder: (context, index) {
                      final icon = habitIcons[index];
                      final isSelected = icon == selectedIcon;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIcon = icon;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: habitIconColors[index].withOpacity(
                              isSelected ? 1 : 0.85,
                            ),

                            borderRadius: BorderRadius.circular(14),
                            border: isSelected
                                ? Border.all(
                                    color: Colors.deepPurpleAccent,
                                    width: 1.5,
                                  )
                                : null,
                          ),
                          child: Center(
                            child: FaIcon(
                              icon,
                              size: 22,
                              color: isSelected
                                  ? Colors.deepPurpleAccent
                                  : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: saveHabit,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xff4e55e0),
                  borderRadius: BorderRadius.circular(50)
                ),
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    'Create',
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

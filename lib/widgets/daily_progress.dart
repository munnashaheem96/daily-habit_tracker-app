import 'package:flutter/material.dart';

class DailyProgress extends StatelessWidget {
  final int done;
  final int total;

  const DailyProgress({
    super.key,
    required this.done,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : done / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${(percent * 100).toInt()}% completed',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                const AlwaysStoppedAnimation(Colors.deepPurpleAccent),
          ),
        ),
      ],
    );
  }
}

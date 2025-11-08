import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamDetailPage extends StatelessWidget {
  final Exam exam;

  const ExamDetailPage({required this.exam});

  String _timeRemaining() {
    final now = DateTime.now();
    final diff = exam.dateTime.difference(now);

    if (diff.isNegative) return 'Испитот е веќе одржан.';

    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;

    List<String> parts = [];

    if (days > 0) {
      parts.add('$days ${days == 1 ? 'ден' : 'дена'}');
    }
    if (hours > 0) {
      parts.add('$hours ${hours == 1 ? 'час' : 'часа'}');
    }
    if (days == 0 && hours == 0 && minutes >= 0) {
      parts.add('$minutes ${minutes <= 1 ? 'минута' : 'минути'}');
    }

    return parts.isNotEmpty ? 'Преостануваат уште ${parts.join(" и ")}' : '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(exam.subject)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Предмет: ${exam.subject}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Датум: ${exam.dateTime.day}.${exam.dateTime.month}.${exam.dateTime.year}'),
            Text('Време: ${exam.dateTime.hour}:${exam.dateTime.minute.toString().padLeft(2, '0')}'),
            SizedBox(height: 8),
            Text('Простории: ${exam.rooms.join(', ')}'),
            SizedBox(height: 16),
            Text(_timeRemaining(), style: TextStyle(fontSize: 16, color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}

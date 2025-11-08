import 'dart:async';
import 'package:flutter/material.dart';
import '../models/exam.dart';

class ExamCard extends StatefulWidget {
  final Exam exam;
  final VoidCallback onTap;

  const ExamCard({required this.exam, required this.onTap, super.key});

  @override
  _ExamCardState createState() => _ExamCardState();
}

class _ExamCardState extends State<ExamCard> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(minutes: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final color = widget.exam.dateTime.isBefore(now)
        ? Colors.orange.shade100
        : Colors.green.shade100;

    return Card(
      color: color,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: ListTile(
        title: Text(widget.exam.subject, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(children: [
              Icon(Icons.calendar_today, size: 16),
              SizedBox(width: 5),
              Text(
                '${widget.exam.dateTime.day}.${widget.exam.dateTime.month}.${widget.exam.dateTime.year} '
                    '${widget.exam.dateTime.hour.toString().padLeft(2, '0')}:${widget.exam.dateTime.minute.toString().padLeft(2, '0')}',
              ),
            ]),
            SizedBox(height: 2),
            Row(children: [
              Icon(Icons.meeting_room, size: 16),
              SizedBox(width: 5),
              Text(widget.exam.rooms.join(', ')),
            ]),
          ],
        ),
        onTap: widget.onTap,
      ),
    );
  }
}

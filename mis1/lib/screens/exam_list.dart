import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'exam_detail.dart';
import '../widgets/exam_card.dart';

class ExamListPage extends StatelessWidget {
  final List<Exam> exams = [
    Exam(
      subject: 'Бази на податоци',
      dateTime: DateTime(2025, 11, 1, 9, 0),
      rooms: ['Амфитеатар'],
    ),
    Exam(
      subject: 'Мобилни информациски системи',
      dateTime: DateTime(2025, 11, 10, 9, 0),
      rooms: ['Лаб 3', 'Лаб 4'],
    ),
    Exam(
      subject: 'Веб програмирање',
      dateTime: DateTime(2025, 11, 15, 10, 0),
      rooms: ['Лаб 2'],
    ),
    Exam(
      subject: 'Напредно програмирање',
      dateTime: DateTime(2025, 11, 17, 11, 0),
      rooms: ['Лаб 1'],
    ),
    Exam(
      subject: 'Компјутерска едукација',
      dateTime: DateTime(2025, 11, 18, 14, 0),
      rooms: ['Лаб 2'],
    ),
    Exam(
      subject: 'Алгоритми и податочни структури',
      dateTime: DateTime(2025, 11, 19, 9, 0),
      rooms: ['Лаб 5'],
    ),
    Exam(
      subject: 'Оперативни системи',
      dateTime: DateTime(2025, 11, 20, 12, 0),
      rooms: ['Амфитеатар'],
    ),
    Exam(
      subject: 'Компјутерски мрежи и безбедност',
      dateTime: DateTime(2025, 11, 22, 10, 0),
      rooms: ['Лаб 3'],
    ),
    Exam(
      subject: 'Напредни бази на податоци',
      dateTime: DateTime(2025, 11, 25, 9, 0),
      rooms: ['Лаб 1'],
    ),
    Exam(
      subject: 'Софтверско инженерство',
      dateTime: DateTime(2025, 11, 26, 11, 0),
      rooms: ['Лаб 2'],
    ),
    Exam(
      subject: 'Вештачка интелигенција',
      dateTime: DateTime(2025, 11, 27, 14, 0),
      rooms: ['Лаб 5'],
    ),
    Exam(
      subject: 'Test',
      dateTime: DateTime(2025, 11, 8, 16, 9),
      rooms: ['Лаб 5'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Scaffold(
      appBar: AppBar(title: Text('Распоред за испити - 221173')),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return ExamCard(
            exam: exam,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExamDetailPage(exam: exam),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(12),
        color: Colors.blue.shade100,
        child: Text(
          'Вкупно испити: ${exams.length}',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

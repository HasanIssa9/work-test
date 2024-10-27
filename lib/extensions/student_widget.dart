import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class StudentWidget extends StatelessWidget {
  StudentWidget({
    super.key,
    required this.student,
    required this.index,
    required this.k,
  });
  final Map student;
  final int index;
  final String k;
  DatabaseReference dbstd = FirebaseDatabase.instance.ref().child('data');
  get textStyle => const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (!kIsWeb)
                  ? CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 25,
                      child: IconButton(
                        onPressed: () {
                          buildShowDialog(context, k);
                        },
                        icon: Icon(
                          Icons.delete_outline,
                          size: 30,
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 8,
              ),
              CircleAvatar(
                backgroundColor: Colors.lightGreen,
                radius: 25,
                child: Text(index.toString(), style: textStyle),
              ),
            ],
          ),
        ),
        Expanded(
            child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.cyan,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  borderText(student: student['stdName']),
                  CircleAvatar(
                    backgroundColor: Colors.lightGreen,
                    radius: (student['id'].toString().length <= 4)
                        ? 25
                        : (student['id'].toString().length <= 5)
                            ? 30
                            : 35,
                    child: Text(student['id'].toString(), style: textStyle),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  borderText(student: student['conName']),
                  borderText(student: student['speName']),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  borderText(student: student['date']),
                  borderText(student: student['empName']),
                ],
              ),
            ],
          ),
        ))
      ],
    );
  }

  Container borderText({required String student}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black),
      ),
      child: Text(student, style: textStyle),
    );
  }

  snackBar(String text) => SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        dismissDirection: DismissDirection.none,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 15),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        content: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 130),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.blueAccent,
            ),
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      );

  Future<void> buildShowDialog(BuildContext context, String? key) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("حذف الطالب"),
            content: const Text("هل انت متأكد من حذف بيانات الطالب؟"),
            actions: [
              TextButton(
                child: const Text("الغاء"),
                onPressed: () {
                  Navigator.of(context).pop();
                  return;
                },
              ),
              TextButton(
                child: const Text("حذف"),
                onPressed: () {
                  dbstd.child(key!).remove();
                  ScaffoldMessenger.of(context).showSnackBar(
                    snackBar(' تم حذف بيانات الطالب ${student['stdName']}'),
                  );
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

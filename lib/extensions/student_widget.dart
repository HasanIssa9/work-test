import 'package:flutter/material.dart';class StudentWidget extends StatelessWidget {  const StudentWidget({    super.key,    required this.student,  });  final Map student;  get textStyle => const TextStyle(fontWeight: FontWeight.bold, fontSize: 18);  @override  Widget build(BuildContext context) {    return Container(      margin: const EdgeInsets.all(6),      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),      decoration: BoxDecoration(        borderRadius: BorderRadius.circular(16.0),        color: Colors.cyan,      ),      child: Column(        mainAxisAlignment: MainAxisAlignment.center,        crossAxisAlignment: CrossAxisAlignment.start,        children: [          Row(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            children: [              borderText(student: student['stdName']),              CircleAvatar(                backgroundColor: Colors.lightGreen,                radius: 25,                child: Text(student['id'].toString(), style: textStyle),              )            ],          ),          const SizedBox(            height: 8,          ),          Row(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            children: [              borderText(student: student['conName']),              borderText(student: student['speName']),            ],          ),          const SizedBox(            height: 5,          ),          Row(            mainAxisAlignment: MainAxisAlignment.spaceBetween,            children: [              borderText(student: student['date']),              borderText(student: student['empName']),            ],          ),        ],      ),    );  }  Container borderText({required String student}) {    return Container(      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 1.5),      decoration: BoxDecoration(        borderRadius: BorderRadius.circular(8),        border: Border.all(color: Colors.black),      ),      child: Text(student, style: textStyle),    );  }}
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:work_app/extensions/student_widget.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});
  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  DatabaseReference dbstd = FirebaseDatabase.instance.ref().child('data');
  TextEditingController searchFilter = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اسماء الطلبة'),
        ),
        body: Column(
          children: [
            Card(
              child: TextFormField(
                controller: searchFilter,
                decoration: InputDecoration(
                  hintText: 'أبحث على اسم الطالب ... ',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Colors.lightGreen,
                      width: 2,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: FirebaseAnimatedList(
                  defaultChild: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  query: dbstd,
                  itemBuilder: (context, snapshot, animation, index) {
                    final title = snapshot.child('stdName').value.toString();
                    if (searchFilter.text.isEmpty) {
                      Map student = snapshot.value as Map;
                      return StudentWidget(
                        student: student,
                        index: index + 1,
                      );
                    } else if (title
                        .toLowerCase()
                        .contains(searchFilter.text.toLowerCase().toString())) {
                      Map student = snapshot.value as Map;
                      return StudentWidget(
                        student: student,
                        index: index + 1,
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

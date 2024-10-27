import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:work_app/extensions/check_id.dart';
import 'package:work_app/views/home_page.dart';
import 'package:work_app/views/students_page.dart';

import '../extensions/dropdown_input.dart';
import '../extensions/qr_scanner.dart';
import '../extensions/snack_bar.dart';
import '../extensions/text_input.dart';

class QrPage extends StatefulWidget {
  const QrPage({super.key});

  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final dbstd = FirebaseDatabase.instance.ref().child('data');
  final _formKey = GlobalKey<FormState>();
  String? _result;
  List<String>? listOfResult = [];

  final TextEditingController number = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController conValue = TextEditingController();
  final TextEditingController speValue = TextEditingController();
  String? empValue = '';
  String? selectedDate = DateFormat('y-MM-d').format(DateTime.now());
  double widthOfResize = 1000;
  CheckId checkId = CheckId();
  void setResult(String result) {
    setState(() {
      _result = result;
      listOfResult = _result?.split('\n');

      // Set each TextEditingController with the respective value from the list
      if (listOfResult != null && listOfResult!.isNotEmpty) {
        number.text = listOfResult!.length > 0 ? listOfResult![0] : '';
        name.text = listOfResult!.length > 1 ? listOfResult![1] : '';
        conValue.text = listOfResult!.length > 2 ? listOfResult![2] : '';
        speValue.text = listOfResult!.length > 3 ? listOfResult![3] : '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StudentsPage()),
              );
            },
            icon: const Icon(Icons.group),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              },
              icon: const Icon(Icons.home),
            ),
            Container(
              width: 25,
            ),
          ],
          elevation: 0,
        ),
        body: Center(
          child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            width: width * 0.97,
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 8),
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22)),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              QrCodeScanner(setResult: setResult),
                        ),
                      ),
                      icon: const Icon(Icons.qr_code),
                      label: const Text('امسح الكود'),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.75,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextInput(
                                  hintName: 'تسلسل: ',
                                  isNumber: true,
                                  controller: number,
                                ),
                                TextInput(
                                  hintName: 'أسم الطالب: ',
                                  controller: name,
                                ),
                                TextInput(
                                  hintName: 'الدولة: ',
                                  controller: conValue,
                                  isCon: true,
                                ),
                                TextInput(
                                  hintName: 'الاختصاص: ',
                                  controller: speValue,
                                  isCon: true,
                                ),
                                DropdownInput(
                                    isEmp: true,
                                    onChanged: (value) {
                                      empValue = value;
                                    }),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.date_range_rounded,
                                      color: Colors.lightGreen,
                                    ),
                                    const SizedBox(
                                      width: 19,
                                    ),
                                    Container(
                                      height: 60,
                                      width: (width <= widthOfResize)
                                          ? width * 0.6
                                          : width * 0.25,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 15),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.lightGreen,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: GestureDetector(
                                        onTap: () async {
                                          try {
                                            final DateTime? picked =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                days: 90)),
                                                    lastDate: DateTime.now()
                                                        .add(const Duration(
                                                            days: 90)));
                                            if (picked != null &&
                                                picked != selectedDate) {
                                              setState(() {
                                                selectedDate =
                                                    DateFormat('y-MM-d')
                                                        .format(picked);
                                              });
                                            }
                                          } catch (e) {
                                            print('Error parsing date: $e');
                                          }
                                        },
                                        child: Text(
                                          selectedDate!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Center(
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.cyan,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 28, vertical: 8),
                                        foregroundColor: Colors.black,
                                        textStyle: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22)),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        String? key = await checkId
                                            .findItemKey(number.text);
                                        bool isExist = await checkId
                                            .checkIfItemExists(key ?? '');
                                        if (isExist &&
                                            key != '' &&
                                            key != null) {
                                          buildShowDialog(context, key);
                                        } else {
                                          dbstd.push().set({
                                            'conName': conValue.text,
                                            'date': selectedDate,
                                            'empName': empValue,
                                            'id': number.text,
                                            'speName': speValue.text,
                                            'stdName': name.text
                                          }).asStream();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBarr.snackBar(
                                                ' تم اضافة الطالب '),
                                          );
                                          setState(() {
                                            number.clear();
                                            name.clear();
                                            conValue.clear();
                                            speValue.clear();
                                          });
                                        }
                                      }
                                    },
                                    icon: const Icon(Icons.add),
                                    label: const Text('اضافة طالب او تحديث'),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> buildShowDialog(BuildContext context, String key) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text("تحديث البيانات"),
            content: const Text("هل تريد تحديث بيانات الطالب؟"),
            actions: [
              TextButton(
                child: const Text("الغاء"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBarr.snackBar(' هذا الطالب موجود ولاحاجة لتحديث '));
                  setState(() {
                    number.clear();
                    name.clear();
                    conValue.clear();
                    speValue.clear();
                  });
                  Navigator.of(context).pop();
                  return;
                },
              ),
              TextButton(
                child: const Text("تحديث"),
                onPressed: () {
                  dbstd.child(key).update({
                    'conName': conValue,
                    'date': selectedDate,
                    'empName': empValue,
                    'id': number.text,
                    'speName': speValue,
                    'stdName': name.text
                  }).asStream();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBarr.snackBar(' تم تحديث بيانات الطالب '),
                  );
                  setState(() {
                    number.clear();
                    name.clear();
                  });
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

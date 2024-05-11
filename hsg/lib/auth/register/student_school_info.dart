import 'package:flutter/material.dart';

import '../../../models/student.dart';
import '../../../services/database_service.dart';
import '../../../services/input_verification.dart';
import '../../../widgets/blue_button.dart';
import '../../../widgets/drop_down_field.dart';
import 'student_extra_info.dart';

class StudentSchoolInfo extends StatefulWidget {
  final Function toggleAuth;
  final Student user;

  const StudentSchoolInfo(
      {required this.toggleAuth, super.key, required this.user});

  @override
  State<StudentSchoolInfo> createState() => _StudentSchoolInfoState();
}

class _StudentSchoolInfoState extends State<StudentSchoolInfo> {
  Map<String, Map<String, dynamic>> schools = {}; // Your User class
  bool isRegistered = false;
  final DatabaseService _databaseService = DatabaseService(uid: '');

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch data when the page is initialized
  }

  void _goToNextPage() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        if (schools[widget.user.schoolId]?['isPrep'] != null &&
            !schools[widget.user.schoolId]?['isPrep']) {
          setState(() {
            widget.user.year = 1;
          });
        }
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentExtraInfo(
                  toggleAuth: widget.toggleAuth, user: widget.user),
            ),
          );
        });
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  Future<void> fetchData() async {
    _databaseService.getSchools().then((value) {
      setState(() {
        schools = value;
      });
    });
  }

  final _formkey = GlobalKey<FormState>();
  double radius = 25;

  void onSchoolChange(dynamic value) {
    setState(() {
      widget.user.schoolId = value;
    });
  }

  void onDepartmentChange(dynamic value) {
    setState(() {
      widget.user.department = value;
    });
  }

  void onYearChange(dynamic value) {
    setState(() {
      widget.user.year =
          schools[widget.user.schoolId]?['classes'][value] as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Create an account (2 of 3)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customDropDownField(
                      schools.keys.toList(),
                      onSchoolChange,
                      validator: (value) => validateText(
                          widget.user.schoolId, 'Please select a value'),
                      Theme.of(context),
                      labelText: "School",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    customDropDownField(
                      schools[widget.user.schoolId]?['departments'],
                      onDepartmentChange,
                      validator: (value) => validateText(
                          widget.user.department, 'Please select a value'),
                      Theme.of(context),
                      labelText: "Department",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (schools[widget.user.schoolId]?['isPrep'] != null &&
                        !schools[widget.user.schoolId]?['isPrep'])
                      customDropDownField(
                        schools[widget.user.schoolId]?['classes'].keys.toList(),
                        onYearChange,
                        validator: (value) => validateText(
                            (widget.user.year == null || widget.user.year == 0)
                                ? ''
                                : 'not zero',
                            'Please select a value'),
                        Theme.of(context),
                        labelText: "Class",
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              BlueButton('Next', _goToNextPage, 20),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: const TextStyle(fontSize: 15),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        widget.toggleAuth(1);
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Sign In',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 56, 107, 246),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

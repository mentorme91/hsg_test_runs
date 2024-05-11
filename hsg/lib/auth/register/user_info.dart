import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/staff.dart';
import '../../../models/student.dart';
import '../../../models/user.dart';
import '../../../services/input_verification.dart';
import '../../../widgets/blue_button.dart';
import '../../../widgets/drop_down_field.dart';
import '../../../widgets/input_field.dart';
import 'staff_school_info.dart';
import 'student_school_info.dart';

class UserInfo extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  final MyUser user;
  const UserInfo(
      {required this.toggleAuth,
      this.message = '',
      super.key,
      required this.user});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  final _formkey = GlobalKey<FormState>();
  double radius = 25;
  String person = "";

  void onEmailChange(String value) {
    setState(() {
      widget.user.email = value;
    });
  }

  void onFirstNameChange(String value) {
    setState(() {
      widget.user.firstName = value;
    });
  }

  void onLastNameChange(String value) {
    setState(() {
      widget.user.lastName = value;
    });
  }

  void onPersonChange(dynamic value) {
    setState(() {
      person = value;
    });
  }

  void _goToNextPage() {
    if (_formkey.currentState != null) {
      if ((_formkey.currentState?.validate() ?? false)) {
        TextInput.finishAutofillContext();
        setState(() {
          if (person == 'Student') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentSchoolInfo(
                    toggleAuth: widget.toggleAuth,
                    user: randomStudent()..updateUserFromUser(widget.user)),
              ),
            );
          }
          if (person == 'Staff') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StaffSchoolInfo(
                    toggleAuth: widget.toggleAuth,
                    user: randomStaff()..updateUserFromUser(widget.user)),
              ),
            );
          }
        });
      }
    } else {
      print(_formkey.currentState?.validate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: const BackButtonIcon(),
          onPressed: () => widget.toggleAuth(0, back: true),
          style: ButtonStyle(
            elevation: const MaterialStatePropertyAll(200),
            iconColor:
                MaterialStatePropertyAll(Color.fromARGB(255, 56, 107, 246)),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Text(
                  'Create an account (1 of 3)',
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
                    customInputField(
                      widget.user.firstName,
                      onFirstNameChange,
                      '',
                      Theme.of(context),
                      validator: (value) => validateText(widget.user.firstName,
                          'Please enter your first name'),
                      labelText: 'First Name',
                      labelSize: 15,
                      changeAllcharacters: true,
                      autofillHints: const [AutofillHints.givenName],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customInputField(
                      widget.user.lastName,
                      onLastNameChange,
                      '',
                      Theme.of(context),
                      validator: (value) => validateText(
                          widget.user.lastName, 'Please enter your last name'),
                      labelText: 'Last Name',
                      labelSize: 15,
                      changeAllcharacters: true,
                      autofillHints: const [AutofillHints.familyName],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    customInputField(
                      widget.user.email,
                      onEmailChange,
                      '',
                      Theme.of(context),
                      validator: (value) => validateText(
                          widget.user.email, 'Please enter an email'),
                      suffixIcon: Icons.email,
                      onIconPressed: null,
                      labelText: 'Email',
                      labelSize: 15,
                      changeAllcharacters: true,
                      autofillHints: const [AutofillHints.email],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    customDropDownField(
                      [
                        'Student',
                        'Staff',
                      ],
                      onPersonChange,
                      validator: (value) =>
                          validateText(person, 'Please select a value'),
                      Theme.of(context),
                      labelText: "I am a",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
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
                    onPressed: () => widget.toggleAuth(1),
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

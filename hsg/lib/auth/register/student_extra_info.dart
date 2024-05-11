import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/student.dart';
import '../../../services/auth_service.dart';
import '../../../services/input_verification.dart';
import '../../../providers/status_provider.dart';
import '../../../widgets/blue_button.dart';
import '../../../widgets/drop_down_field.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/loading.dart';

class StudentExtraInfo extends StatefulWidget {
  final Function toggleAuth;
  final Student user;

  const StudentExtraInfo(
      {required this.toggleAuth, super.key, required this.user});

  @override
  State<StudentExtraInfo> createState() => _StudentExtraInfoState();
}

class _StudentExtraInfoState extends State<StudentExtraInfo> {
  void onCreate() async {
    TextInput.finishAutofillContext();
    bool res = await _createAccount();
    if (res) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<bool> _createAccount() async {
    if (_formkey.currentState != null) {
      if (_formkey.currentState?.validate() ?? false) {
        TextInput.finishAutofillContext();
        print(widget.user.toMap());
        if (!widget.user.isValidStudent()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Please go back and refill all the fields"),
            ),
          );
          return false;
        }
        setState(() {
          loading = true;
        });
        await Provider.of<StatusProvider>(context, listen: false)
            .changeStatus('Student');
        User? user;
        String? err;
        (user, err) = await _auth.registerStudent(widget.user);
        if (user == null) {
          setState(() {
            loading = false;
            message = err;
          });
        } else {
          TextInput.finishAutofillContext();
          print('Success');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  "Account created successfully! Please go and log in if you haven't already been logged in."),
            ),
          );
          setState(() {
            loading = false;
          });
          return true;
        }
      }
    } else {
      print(_formkey.currentState?.validate());
    }
    return false;
  }

  bool loading = false;
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  double radius = 25;
  bool obscure = false, reobscure = false;
  String retypePassword = '';
  String? message;

  void onPasswordChange(String value) {
    setState(() {
      widget.user.password = value;
    });
  }

  void onRetypePasswordChange(String value) {
    setState(() {
      retypePassword = value;
    });
  }

  void onStatusChange(dynamic value) {
    setState(() {
      widget.user.status = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (loading)
        ? LoadingScreen()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(),
            body: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                    child: Column(children: [
                  Center(
                    child: Text(
                      'Create an account (3 of 3)',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (message != null)
                    Center(
                      child: Text(
                        message ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  Form(
                    key: _formkey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customDropDownField(
                          ["Mentor", "Mentee", "Both", "Visitor"],
                          onStatusChange,
                          validator: (value) => validateText(
                              widget.user.status, 'Please select a value'),
                          Theme.of(context),
                          labelText: "Status",
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        customInputField(retypePassword, onPasswordChange, '',
                            Theme.of(context),
                            validator: (value) =>
                                validatePassword(widget.user.password),
                            suffixIcon: !obscure
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            onIconPressed: (val) {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            obscureText: !obscure,
                            labelText: 'Password',
                            labelSize: 15,
                            changeAllcharacters: true,
                            autofillHints: const [AutofillHints.password]),
                        SizedBox(
                          height: 20,
                        ),
                        customInputField(widget.user.password ?? '',
                            onRetypePasswordChange, '', Theme.of(context),
                            validator: (value) =>
                                (retypePassword == widget.user.password)
                                    ? null
                                    : 'Passwords do not match',
                            suffixIcon: !reobscure
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            onIconPressed: (val) {
                              setState(() {
                                reobscure = !reobscure;
                              });
                            },
                            obscureText: !reobscure,
                            labelText: 'Retype password',
                            labelSize: 15,
                            changeAllcharacters: true,
                            autofillHints: const [AutofillHints.password]),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  BlueButton('Create Account', onCreate, 20),
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
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Log in',
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
                ]))),
          );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/input_verification.dart';
import '../../providers/status_provider.dart';
import '../../widgets/blue_button.dart';
import '../../widgets/drop_down_field.dart';
import '../../widgets/input_field.dart';
import '../../widgets/loading.dart';
import '../services/database_service.dart';

class SignIn extends StatefulWidget {
  final Function toggleAuth;
  final String message;
  const SignIn({required this.toggleAuth, this.message = '', super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth =
      AuthService(); // auth service used to sign in to firebase
  String email = '', password = '';
  final _formkey = GlobalKey<FormState>(); // used to validate inputs
  bool loading = false; // used to display loading screen
  String? wrongCredentials; // display error of wrong credentials
  bool obscure = false;
  double radius = 25;
  String person = '';

  @override
  Widget build(BuildContext context) {
    wrongCredentials ??= widget.message;

    void onEmailChange(String value) {
      setState(() {
        email = value.trim();
      });
    }

    void onPasswordChange(String value) {
      setState(() {
        password = value.trim();
      });
    }

    void signIn() async {
      if (_formkey.currentState != null) {
        if (_formkey.currentState?.validate() ?? false) {
          setState(() {
            loading = true;
          });
          Provider.of<StatusProvider>(context, listen: false)
              .changeStatus(person);
          User? authUser;
          String? err;
          (authUser, err) = await _auth.signInUser(email, password);
          if (authUser == null) {
            setState(() {
              loading = false;
            });
            setState(() {
              wrongCredentials = err;
            });
          } else {
            MyUser? user = await createUserFromAuthUser(authUser, person);

            if (user == null) {
              setState(() {
                loading = false;
              });
              setState(() {
                wrongCredentials = 'User is not a $person';
              });
              _auth.signOut();
              print('Failed to sign in');
            } else {
              print('Success');
              bool isSuper =
                  await DatabaseService(uid: user.uid).isSuperUser(user.email);
              if (isSuper) {
                return;
              }
            }
          }
        }
      } else {
        print(_formkey.currentState?.validate());
      }
    }

    return loading
        ? LoadingScreen() //loading screen
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Theme.of(context).colorScheme.background,
              leading: IconButton(
                icon: const BackButtonIcon(),
                onPressed: () => widget.toggleAuth(0, back: true),
                style: const ButtonStyle(
                  elevation: MaterialStatePropertyAll(200),
                  iconColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 56, 107, 246)),
                ),
              ),
            ),
            body: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        'Log In',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 30),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        '$wrongCredentials',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: _formkey,
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            customDropDownField(
                              [
                                'Student',
                                'Staff',
                              ],
                              (val) => person = val,
                              validator: (value) =>
                                  validateText(person, 'Please select a value'),
                              Theme.of(context),
                              labelText: "I am a",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            customInputField(
                                email, onEmailChange, '', Theme.of(context),
                                validator: (value) => validateText(
                                    email, 'Please enter an email'),
                                suffixIcon: Icons.email,
                                onIconPressed: null,
                                labelText: 'Email',
                                labelSize: 15,
                                changeAllcharacters: true,
                                autofillHints: const [AutofillHints.email],
                                onEditingComplete: () =>
                                    TextInput.finishAutofillContext()),
                            SizedBox(
                              height: 20,
                            ),
                            customInputField(password, onPasswordChange, '',
                                Theme.of(context),
                                validator: (value) =>
                                    validatePassword(password),
                                suffixIcon: obscure
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
                                autofillHints: const [AutofillHints.password],
                                onEditingComplete: () =>
                                    TextInput.finishAutofillContext()),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      widget.toggleAuth(3);
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 56, 107, 246),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BlueButton('Log In', signIn, 80),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account? ',
                        ),
                        TextButton(
                          onPressed: () => widget.toggleAuth(2),
                          child: Text(
                            'Create one',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 56, 107, 246)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
  }
}

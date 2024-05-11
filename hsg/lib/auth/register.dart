import 'package:flutter/material.dart';

import '../../models/user.dart';
import 'register/user_info.dart';

class Register extends StatefulWidget {
  final Function toggleAuth;
  Register({required this.toggleAuth});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  MyUser user = MyUser(email: '', uid: '', firstName: '', lastName: '', schoolId: '');

  @override
  Widget build(BuildContext context) {
    return UserInfo(toggleAuth: widget.toggleAuth, user: user);
  }
}

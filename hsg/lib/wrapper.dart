// This file contains the wrapper which navigates between the
// home screen (when a user is signed in) and
//the authenticate screen (when a user is signed out)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/status_provider.dart';
import 'auth/authenticate.dart';
import 'home.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Provider.of<StatusProvider>(context, listen: false).initializeStatus();
  }

  @override
  Widget build(BuildContext context) {
    /// get user information to determine whether user is signed in or not (not null or null)
    final MyUser? user = Provider.of<MyUser?>(context);
    return (user == null) ? const Auhenticate() : HomePage();
  }
}

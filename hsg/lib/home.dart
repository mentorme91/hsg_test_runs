import 'package:flutter/material.dart';
import 'package:hsg/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MyUser user = Provider.of<MyUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          Text('Welcome ${user.firstName} to the Home Page!'),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                AuthService().signOut();
              },
              child: Text('Sign Out!'),
            ),
          ),
        ],
      ),
    );
  }
}

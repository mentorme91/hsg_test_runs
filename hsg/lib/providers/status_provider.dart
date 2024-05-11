import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatusProvider with ChangeNotifier {
  String _status = 'Student'; // Default status is 'Student'

  StatusProvider(this._status);

  // Getter for status property
  String get status => _status;

  // SharedPreferences key for status
  static const String _statusKey = 'user_status';

  // Method to change the value of status
  Future<void> changeStatus(String userStatus) async {
    _status = userStatus;
    notifyListeners();
    // Save the new status to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statusKey, _status);
  }

  // Method to initialize the status from SharedPreferences
  Future<String> initializeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String savedStatus = prefs.getString(_statusKey) ?? _status;
    _status = savedStatus;
    return savedStatus;
  }
}

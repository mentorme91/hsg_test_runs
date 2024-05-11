import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/staff.dart';
import '../models/student.dart';
import '../models/user.dart';
import 'database_service.dart';

// this class control our firebase authentication
class AuthService extends ChangeNotifier {
  // This serves as our entry point into firebase authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get changes made to our auth service user
  Stream<MyUser?> user(String person) {
    return _auth
        .authStateChanges()
        .asyncMap((event) => createUserFromAuthUser(event, person));
  }

  // method to signin a user using email and password
  Future<(User?, String?)> signInUser(email, password) async {
    try {
      UserCredential res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return (res.user, null);
    } on FirebaseAuthException catch (e) {
      String code = e.code;
      if (code == 'user-not-found') {
        return (null, 'User not found');
      } else if (code == 'invalid-password') {
        return (null, 'Wrong password');
      } else if (code == 'invalid-email') {
        return (null, 'Invalid email');
      } else if (code == 'auth/internal-error') {
        return (null, 'Internal error');
      } else if (code == 'invalid-credential') {
        return (null, 'Incorrect credentials');
      } else {
        return (null, 'Unknown error');
      }
    }
  }

  // signs out a user
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  // method to register a user
  Future<(User?, String?)> registerStudent(Student user) async {
    try {
      // register user with email and password from firebase auth service and get user credentials
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password ?? '');
      // use user credentials to create an instance of database service for user or update user
      user.uid = res.user?.uid ?? '';
      res.user?.updateDisplayName(user.firstName);
      await DatabaseService(uid: res.user?.uid).updateStudentCollection(user);
      return (res.user, null);
    } on FirebaseAuthException catch (e) {
      // if an error was thrown, return null
      String code = e.code;
      if (code == 'email-already-in-use') {
        return (null, 'Email already exists');
      } else if (code == 'invalid-email') {
        return (null, 'Invalid email');
      } else if (code == 'invalid-password') {
        return (null, 'Weak password');
      } else {
        print(code);
        return (null, 'Unknown error');
      }
    } catch (e) {
      return (null, 'Unknown error');
    }
  }

  // method to register a user
  Future registerStaff(Staff user) async {
    try {
      // register user with email and password from firebase auth service and get user credentials
      UserCredential res = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password ?? '');
      // use user credentials to create an instance of database service for user or update user
      user.uid = res.user?.uid ?? '';
      res.user?.updateDisplayName(user.firstName);
      await DatabaseService(uid: res.user?.uid).updateStaffCollection(user);
      return (res.user, null);
    } on FirebaseAuthException catch (e) {
      // if an error was thrown, return null
      String code = e.code;
      if (code == 'email-already-in-use') {
        return (null, 'Email already in use');
      } else if (code == 'invalid-email') {
        return (null, 'Invalid email');
      } else if (code == 'invalid-password') {
        return (null, 'Weak password');
      } else {
        return (null, 'Unknown error');
      }
    } catch (e) {
      return (null, 'Unknown error');
    }
  }

  // this function resets a user's password from the forgot password page
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      print('Error sending password reset email: $e');
      return null;
    }
  }
}

// create a custom user class from Firebase user class
Future<MyUser?> createUserFromAuthUser(User? authUser, String person) async {
  // get a snapshot of all student data
  if (authUser == null) {
    return null;
  }
  if (person == 'Student') {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('all_students')
        .doc(authUser.uid)
        .get();

    // get student data as a dictionary (Map<String, dynamic>)
    dynamic UserData = snapshot.data();
    // try creating user object from dictionary
    try {
      // return null is user data is null
      if (UserData == null) {
        throw Error();
      }

      // create user instance
      Student user = Student.fromMap(UserData);
      return user;
    } catch (e) {
      // else return null
      return null;
    }
  } else {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('all_staff')
        .doc(authUser.uid)
        .get();
    dynamic UserData = snapshot.data();
    // try creating user object from dictionary
    try {
      // return null is user data is null
      if (UserData == null) {
        throw Error();
      }

      // create user instance
      Staff user = Staff.fromMap(UserData);
      return user;
    } catch (e) {
      print(e.toString());
      // else return null
      return null;
    }
  }
}

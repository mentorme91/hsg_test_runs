import 'request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  String uid;
  String email;
  String firstName;
  String lastName;
  String schoolId;
  // String? faculty;
  String? department;
  String? _password;
  String? photoURL;
  String? about;
  Map<String, Timestamp?> connections = {};
  List<String> cancels = [];
  List<String> rejects = [];
  Map<String, Request> requests = {};

  // User constructor
  MyUser({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.schoolId,
    this.department,
    this.photoURL,
    this.about,
    this.connections = const {},
    this.cancels = const [],
    this.rejects = const [],
    this.requests = const {},
  });

  factory MyUser.fromMap(Map<dynamic, dynamic> userData) {
    Map<String, Request> req =
        ((userData['requests'] ?? {}) as Map<String, dynamic>).map(
      (key, value) {
        return MapEntry(
          key,
          Request(
            recieverUID: value['reciever'],
            senderUID: value['sender'],
            status: Status.values[value['status']],
          ),
        );
      },
    );

    return MyUser(
        uid: userData['uid'],
        email: userData['email'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        schoolId: userData['school_id'],
        department: userData['department'],
        photoURL: userData['photoURL'],
        about: userData['about'],
        connections: (userData['connections'] ?? {}).cast<String, Timestamp?>(),
        cancels: (userData['cancels'] ?? []).cast<String>(),
        rejects: (userData['rejects'] ?? []).cast<String>(),
        requests: (req).cast<String, Request>());
  }

  // get user password
  String? get password => _password;
  // set user password
  set password(String? pass) => _password = pass;

  // still to implement
  Map<String, dynamic> toMap() {
    Map<String, Map<String, dynamic>> mapreqs;
    if (requests.isEmpty) {
      mapreqs = {};
    } else {
      mapreqs = (requests as Map<String, Request>).map(
        (key, value) {
          return MapEntry(
            key,
            value.toMap(),
          );
        },
      );
    }
    Map<String, dynamic> userDict = {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'school_id': schoolId,
      'department': department,
      'photoURL': photoURL,
      'about': about,
      'connections': connections,
      'requests': mapreqs,
      'cancels': cancels,
      'rejects': rejects,
    };
    return userDict;
  }

  // update a [MyUser] class from an Authentication User class (from Firebase)
  void updateUserFromUser(MyUser user) {
    _password = password;
    uid = user.uid;
    firstName = user.firstName;
    lastName = user.lastName;
    email = user.email;
    schoolId = user.schoolId;
    department = user.department;
    photoURL = user.photoURL;
    about = user.about;
    connections = user.connections;
    cancels = user.cancels;
    rejects = user.rejects;
    requests = user.requests;
  }

  // update user object from a map
  void updateFromMap(Map userData) {
    uid = userData['uid'];
    email = userData['email'];
    firstName = userData['first_name'];
    lastName = userData['last_name'];
    schoolId = userData['school_id'];
    department = userData['department'];
    about = userData['about'];
    photoURL = userData['photoURL'];
    Map<String, dynamic> conns = userData['connections'] ?? {};
    connections = conns.cast<String, Timestamp?>();
    List<dynamic> rejs = userData['rejects'] ?? [];
    rejects = rejs.cast<String>();
    List<dynamic> cns = userData['cancels'] ?? [];
    cancels = cns.cast<String>();
    Map<String, dynamic> reqs = userData['requests'] ?? {};
    requests = reqs.map(
      (key, value) => MapEntry(
        key,
        Request(
          recieverUID: value['reciever'],
          senderUID: value['sender'],
          status: Status.values[value['status']],
        ),
      ),
    );
  }

  bool isValidUser() {
    return email.trim().isNotEmpty &&
        firstName.trim().isNotEmpty &&
        lastName.trim().isNotEmpty &&
        schoolId.trim().isNotEmpty;
  }
}

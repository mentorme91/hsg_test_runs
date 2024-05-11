import 'assignment.dart';

class Course {
  String courseTitle;
  String schoolName;
  String courseDescription;
  List<String> instructors;
  String courseID;
  String courseChatID;
  String courseDocumentsID;
  List<Assignment> courseAssignments;
  List<String> registeredStudents;
  List<String> exams;
  List<String> tests;
  String courseImageURL; // Added courseImageURL property

  Course({
    this.courseTitle = '',
    this.schoolName = '',
    this.courseDescription = '',
    this.instructors = const [],
    this.courseID = '',
    this.courseChatID = '',
    this.courseDocumentsID = '',
    this.courseAssignments = const [],
    this.registeredStudents = const [],
    this.courseImageURL = '',
    this.exams = const [],
    this.tests = const [],

    // Added courseImageURL parameter
  });

  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      courseTitle: data['courseTitle'],
      schoolName: data['schoolName'],
      courseDescription: data['courseDescription'],
      courseID: data['courseID'],
      courseChatID: data['courseChatID'],
      courseDocumentsID: data['courseDocumentsID'],
      courseImageURL:
          data['courseImageURL'] ?? '', // Added courseImageURL property
      instructors: ((data['instructors'] as List<dynamic>).cast<String>())
          .toSet()
          .toList(),
      registeredStudents:
          ((data['registeredStudents'] as List<dynamic>).cast<String>())
              .toSet()
              .toList(),
      courseAssignments: (data['courseAssignments'] as List<dynamic>)
          .map((assignment) => Assignment.fromMap(assignment))
          .toList(),
      exams: (data['exams'] as List<dynamic>).cast<String>(),
      tests: (data['tests'] as List<dynamic>).cast<String>(),
    );
  }

  void updateFromMap(Map<String, dynamic> data) {
    courseTitle = data['courseTitle'];
    schoolName = data['schoolName'];
    courseDescription = data['courseDescription'];
    courseID = data['courseID'];
    courseChatID = data['courseChatID'];
    courseImageURL =
        data['courseImageURL'] ?? ''; // Added courseImageURL property
    courseDocumentsID = data['courseDocumentsID'];
    List<dynamic> ins = data['instructors'] as List<dynamic>;
    instructors = ins.cast<String>();
    List<dynamic> reg = data['registeredStudents'] as List<dynamic>;
    registeredStudents = reg.cast<String>();
    List<dynamic> assignments = data['courseAssignments'] as List<dynamic>;
    courseAssignments = [];
    for (var assignment in assignments) {
      Map<String, dynamic> assignmentData = assignment as Map<String, dynamic>;
      courseAssignments.add(Assignment.fromMap(assignmentData));
    }
    List<dynamic> ex = data['exams'] as List<dynamic>;
    exams = ex.cast<String>();
    List<dynamic> te = data['tests'] as List<dynamic>;
    tests = te.cast<String>();
  }

  Map<String, dynamic> toMap() {
    return {
      'courseTitle': courseTitle,
      'schoolName': schoolName,
      'courseDescription': courseDescription,
      'instructors': instructors,
      'courseID': courseID,
      'courseChatID': courseChatID,
      'courseDocumentsID': courseDocumentsID,
      'courseAssignments':
          courseAssignments.map((assignment) => assignment.toMap()).toList(),
      'registeredStudents': registeredStudents,
      'courseImageURL': courseImageURL, // Added courseImageURL property
      'exams': exams,
      'tests': tests,
    };
  }

  // copywith
  Course copyWith({
    String? courseTitle,
    String? schoolName,
    String? courseDescription,
    List<String>? instructors,
    String? courseID,
    String? courseChatID,
    String? courseDocumentsID,
    List<Assignment>? courseAssignments,
    List<String>? registeredStudents,
    List<String>? exams,
    List<String>? tests,
    String? courseImageURL, // Added courseImageURL property
  }) {
    return Course(
      courseTitle: courseTitle ?? this.courseTitle,
      schoolName: schoolName ?? this.schoolName,
      courseDescription: courseDescription ?? this.courseDescription,
      instructors: instructors ?? this.instructors,
      courseID: courseID ?? this.courseID,
      courseChatID: courseChatID ?? this.courseChatID,
      courseDocumentsID: courseDocumentsID ?? this.courseDocumentsID,
      courseAssignments: courseAssignments ?? this.courseAssignments,
      registeredStudents: registeredStudents ?? this.registeredStudents,
      exams: exams ?? this.exams,
      tests: tests ?? this.tests,
      courseImageURL: courseImageURL ??
          this.courseImageURL, // Added courseImageURL property
    );
  }
}

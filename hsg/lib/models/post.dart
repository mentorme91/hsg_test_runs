import 'package:cloud_firestore/cloud_firestore.dart';

// custom post class for Posts
class Post {
  String? userPhotoURL;
  String id;
  String postUserId;
  String content, title, userName;
  int likes = 0;
  List comments = [];
  List<String> likedBy = [];
  Timestamp? time = Timestamp.now();

  Post({
    required this.content,
    required this.title,
    required this.userName,
    required this.id,
    required this.postUserId,
    this.likes = 0,
    this.userPhotoURL,
    this.likedBy = const [],
    this.time,
  });

  // convert post information to map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'photoURL': userPhotoURL,
      'name': userName,
      'title': title,
      'content': content,
      'time': time,
      'likes': likes,
      'comments': comments,
      'likedBy': likedBy,
      'postUserId': postUserId,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] ?? '',
      postUserId: map['postUserId'] ?? '',
      content: map['content'],
      title: map['title'],
      userName: map['name'],
      likes: map['likes'],
      userPhotoURL: map['photoURL'],
      likedBy: List<String>.from(map['likedBy'] ?? []),
      time: map['time'] as Timestamp?,
    );
  }
}

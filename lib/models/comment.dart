import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String userEmail;
  final String text;
  final DateTime timestamp;

  Comment({
    required this.id,
    required this.userEmail,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromMap(Map<String, dynamic> data, String id) {
    return Comment(
      id: id,
      userEmail: data['userEmail'] ?? '',
      text: data['text'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

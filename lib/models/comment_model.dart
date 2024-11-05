import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  String id;
  String commenterId;
  String comment;
  DateTime timestamp;

  Comment({
    required this.id,
    required this.commenterId,
    required this.comment,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'commenterId': commenterId,
      'comment': comment,
      'timestamp': timestamp,
    };
  }

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      commenterId: data['commenterId'] ?? '',
      comment: data['comment'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

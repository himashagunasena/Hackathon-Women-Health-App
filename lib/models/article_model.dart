import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String id;
  String title;
  String category;
  String content;
  String imageUrl;
  String authorName;
  String userType;
  DateTime timestamp;

  Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    required this.imageUrl,
    required this.authorName,
    required this.userType,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'content': content,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'userType': userType,
      'timestamp': timestamp,
    };
  }

  factory Article.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Article(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? "others",
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      authorName: data['authorName'] ?? '',
      timestamp: data['timestamp'] ?? DateTime.now(),
      userType: data['userType'] ?? "User",
    );
  }
}

import 'package:flutter/foundation.dart';

class PushMessage {
  final String title;
  final String body;
  final String? imageUrl;

  PushMessage({
    required this.title,
    required this.body,
    this.imageUrl,
  });

  factory PushMessage.fromJson(Map<String, dynamic> json) {
    return PushMessage(
      title: json['title'],
      body: json['body'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };
  }
}



class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageUrl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    this.data,
    this.imageUrl,
  });

  @override
  String toString() {
    return '''
PushMessage: $messageId
title: $title
body: $body
sentDate: $sentDate
data: $data
imageUrl: $imageUrl
''';
  }

  // Convert PushMessage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'title': title,
      'body': body,
      'sentDate': sentDate.toIso8601String(),
      'data': data,
      'imageUrl': imageUrl,
    };
  }

  // Convert JSON to PushMessage object
  factory PushMessage.fromJson(Map<String, dynamic> json) {
    return PushMessage(
      messageId: json['messageId'],
      title: json['title'],
      body: json['body'],
      sentDate: DateTime.parse(json['sentDate']),
      data:
          json['data'] != null ? Map<String, dynamic>.from(json['data']) : null,
      imageUrl: json['imageUrl'],
    );
  }
}

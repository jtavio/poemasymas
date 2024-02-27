class PushMessage {
  final String messageId;
  final String title;
  final String body;
  final DateTime sentDate;
  final Map<String, dynamic>? data;
  final String? imageurl;

  PushMessage({
    required this.messageId,
    required this.title,
    required this.body,
    required this.sentDate,
    required this.data,
    required this.imageurl,
  });

  @override
  String toString() {
    return '''
    PushMessage - id: $messageId,
    title: $title,
    body: $body,
    sentDate: $sentDate,
    data: $data,
    imageurl: $imageurl
    ''';
  }
}

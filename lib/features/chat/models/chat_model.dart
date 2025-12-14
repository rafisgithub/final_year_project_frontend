class ChatUser {
  final int id;
  final String name;
  final String? avatar;
  final String? email;
  final String? phone;
  final String? role;
  final String? storeName;
  final int? unreadCount;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final bool? isOnline;

  ChatUser({
    required this.id,
    required this.name,
    this.avatar,
    this.email,
    this.phone,
    this.role,
    this.storeName,
    this.unreadCount,
    this.lastMessage,
    this.lastMessageTime,
    this.isOnline,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] ?? 'Unknown User',
      avatar: json['avatar'],
      email: json['email'],
      phone: json['phone_number'],
      role: json['role'],
      storeName: json['store_name'] ?? json['name'],
      unreadCount: json['unread_message_count'] ?? json['unread_count'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null
          ? DateTime.tryParse(json['last_message_time'])
          : null,
      isOnline: json['is_online'] ?? false,
    );
  }
}

class ChatMessage {
  final int id;
  final String? message;
  final int senderId;
  final int receiverId;
  final DateTime timestamp;
  final bool isRead;
  final String? type;
  final String? reaction;
  final String? fileUrl;

  ChatMessage({
    required this.id,
    this.message,
    required this.senderId,
    required this.receiverId,
    required this.timestamp,
    this.isRead = false,
    this.type,
    this.reaction,
    this.fileUrl,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    print('📥 [ChatMessage] Parsing JSON: $json');

    try {
      final message = ChatMessage(
        id: json['message_id'] ?? json['id'] ?? 0,
        message: json['content'] ?? json['message'],
        senderId: json['sender_id'] ?? json['sender'] ?? 0,
        receiverId: json['receiver_id'] ?? json['receiver'] ?? 0,
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : DateTime.now(),
        isRead: json['is_read'] ?? false,
        type: json['message_type'] ?? json['type'],

        reaction:
            json['reaction'] ??
            (json['reactions'] != null && (json['reactions'] as List).isNotEmpty
                ? (json['reactions'] as List).last['emoji']
                : null),
        fileUrl: json['file'] ?? json['file_url'],
      );

      print(
        '✅ [ChatMessage] Parsed successfully: ID=${message.id}, Sender=${message.senderId}',
      );
      return message;
    } catch (e) {
      print('❌ [ChatMessage] Parse error: $e');
      print('❌ [ChatMessage] Failed JSON: $json');
      rethrow;
    }
  }
}

import 'package:dio/dio.dart';
import '../../../../networks/dio/dio.dart';
import '../../../../networks/endpoints.dart';
import '../models/chat_model.dart';

class ChatService {
  // Get list of users chat history
  static Future<Map<String, dynamic>> getChatList() async {
    try {
      final response = await getHttp(Endpoints.chatList, null);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final users = data.map((json) => ChatUser.fromJson(json)).toList();
        return {'success': true, 'data': users};
      }
      return {'success': false, 'message': 'Failed to load chats'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get chat history with a specific user
  static Future<Map<String, dynamic>> getMessages(int userId) async {
    try {
      final response = await getHttp('${Endpoints.chatMessages}$userId/', null);
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final messages = data
            .map((json) => ChatMessage.fromJson(json))
            .toList();
        return {'success': true, 'data': messages};
      }
      return {'success': false, 'message': 'Failed to load messages'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // React to a message
  static Future<Map<String, dynamic>> reactToMessage(
    int messageId,
    String emoji,
  ) async {
    try {
      final response = await postHttp(Endpoints.chatReaction, {
        "message_id": messageId,
        "emoji": emoji,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'message': 'Reaction added successfully'};
      }
      return {'success': false, 'message': 'Failed to add reaction'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Send file message
  static Future<Map<String, dynamic>> sendFileMessage(
    int receiverId,
    String filePath, {
    String? caption,
  }) async {
    try {
      String fileName = filePath.split('/').last;
      FormData formData = FormData.fromMap({
        'receiver_id': receiverId,
        'file': await MultipartFile.fromFile(filePath, filename: fileName),
        'caption': caption ?? '',
      });

      final response = await postHttp(Endpoints.chatSendFile, formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {'success': true, 'data': response.data['data']};
      }
      return {'success': false, 'message': 'Failed to send file'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Search users
  static Future<Map<String, dynamic>> searchUsers(String query) async {
    try {
      final response = await getHttp(
        '${Endpoints.chatSearch}?name=$query',
        null,
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'] ?? [];
        final users = data.map((json) => ChatUser.fromJson(json)).toList();
        return {'success': true, 'data': users};
      }
      return {'success': false, 'message': 'Search failed'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get total unread message count
  static Future<Map<String, dynamic>> getUnreadMessageCount() async {
    try {
      final response = await getHttp(Endpoints.allUnreadMessagesCount, null);
      if (response.statusCode == 200) {
        return {'success': true, 'data': response.data['data']};
      }
      return {'success': false, 'message': 'Failed to get unread count'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

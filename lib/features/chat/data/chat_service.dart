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
}

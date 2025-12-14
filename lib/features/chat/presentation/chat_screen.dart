import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../networks/endpoints.dart';
import '../../../../networks/websocket_service.dart';
import '../../../../constants/app_constants.dart';
import '../data/chat_service.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser otherUser;

  const ChatScreen({super.key, required this.otherUser});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final WebSocketService _webSocketService = WebSocketService();

  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  int _currentUserId = 0;
  bool _isOtherUserTyping = false;
  Timer? _typingTimer;
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _loadCurrentUserId();
    _loadHistory();
    _connectWebSocket();
  }

  void _loadLanguage() {
    final lang = GetStorage().read(kKeyLanguage) ?? 'en';
    setState(() => _currentLanguage = lang);
  }

  String _translate(String en, String bn) {
    return _currentLanguage == 'bn' ? bn : en;
  }

  void _loadCurrentUserId() {
    final id = GetStorage().read(kKeyUserID);
    if (id is int) {
      _currentUserId = id;
    } else if (id is String) {
      _currentUserId = int.tryParse(id) ?? 0;
    } else {
      _currentUserId = 0;
    }
  }

  Future<void> _loadHistory() async {
    final result = await ChatService.getMessages(widget.otherUser.id);
    if (mounted) {
      if (result['success'] == true) {
        setState(() {
          _messages = List<ChatMessage>.from(result['data']);
          _isLoading = false;
        });
        _scrollToBottom();
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  void _connectWebSocket() {
    if (_currentUserId == 0) {
      print('❌ [ChatScreen] Cannot connect - current user ID is 0');
      return;
    }

    print('🔌 [ChatScreen] Connecting WebSocket...');
    print(
      '🔌 [ChatScreen] Current User: $_currentUserId, Other User: ${widget.otherUser.id}',
    );

    // Connect with current user as sender and other user as receiver
    _webSocketService.connect(_currentUserId, widget.otherUser.id);

    print('👂 [ChatScreen] Setting up message listener...');
    _webSocketService.messages.listen(
      (data) {
        print('📨 [ChatScreen] Received data from WebSocket: $data');

        if (!mounted) {
          print('⚠️ [ChatScreen] Widget not mounted, ignoring message');
          return;
        }

        final messageType = data['type'];
        print('📋 [ChatScreen] Message type: $messageType');

        if (messageType == 'chat_message' || data['message'] != null) {
          print('💬 [ChatScreen] Processing chat message...');
          try {
            final newMessage = ChatMessage.fromJson(data);
            print('✅ [ChatScreen] Message parsed, adding to list');
            setState(() {
              _messages.add(newMessage);
            });
            print('✅ [ChatScreen] UI updated with new message');
            _scrollToBottom();
          } catch (e) {
            print('❌ [ChatScreen] Error parsing message: $e');
          }
        } else if (messageType == 'user_typing') {
          print('⌨️ [ChatScreen] User typing notification');
          setState(() => _isOtherUserTyping = true);
          _typingTimer?.cancel();
          _typingTimer = Timer(const Duration(seconds: 2), () {
            if (mounted) setState(() => _isOtherUserTyping = false);
          });
        } else {
          print('⚠️ [ChatScreen] Unknown message type or format: $data');
        }
      },
      onError: (error) {
        print('❌ [ChatScreen] WebSocket listen error: $error');
      },
      onDone: () {
        print('⚠️ [ChatScreen] WebSocket stream closed');
      },
    );

    print('✅ [ChatScreen] WebSocket listener setup complete');
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _webSocketService.sendMessage(text);
    _messageController.clear();
  }

  @override
  void dispose() {
    _webSocketService.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.button, AppColors.c28B446],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      backgroundImage: widget.otherUser.avatar != null
                          ? NetworkImage('$imageUrl${widget.otherUser.avatar}')
                          : null,
                      child: widget.otherUser.avatar == null
                          ? Text(
                              widget.otherUser.name[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    if (widget.otherUser.isOnline == true)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.otherUser.storeName ?? widget.otherUser.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (_isOtherUserTyping)
                        Text(
                          _translate('Typing...', 'লিখছে...'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      else if (widget.otherUser.isOnline == true)
                        Text(
                          _translate('Online', 'অনলাইন'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12.sp,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.call, color: Colors.white, size: 24.sp),
                onPressed: () {
                  // TODO: Implement audio call
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _translate(
                          'Audio call coming soon',
                          'অডিও কল শীঘ্রই আসছে',
                        ),
                      ),
                      backgroundColor: AppColors.button,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.videocam, color: Colors.white, size: 26.sp),
                onPressed: () {
                  // TODO: Implement video call
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _translate(
                          'Video call coming soon',
                          'ভিডিও কল শীঘ্রই আসছে',
                        ),
                      ),
                      backgroundColor: AppColors.button,
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
              SizedBox(width: 4.w),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.button,
                      strokeWidth: 3,
                    ),
                  )
                : _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 16.h,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isSent = message.senderId == _currentUserId;
                      final showAvatar =
                          !isSent &&
                          (index == _messages.length - 1 ||
                              _messages[index + 1].senderId !=
                                  message.senderId);
                      return _buildMessageBubble(message, isSent, showAvatar);
                    },
                  ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 64.sp, color: Colors.grey[300]),
          SizedBox(height: 16.h),
          Text(
            _translate('No messages yet', 'এখনও কোন বার্তা নেই'),
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _translate(
              'Send a message to start chatting',
              'চ্যাট শুরু করতে একটি বার্তা পাঠান',
            ),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    ChatMessage message,
    bool isSent,
    bool showAvatar,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: isSent
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSent && showAvatar)
            CircleAvatar(
              radius: 16.r,
              backgroundColor: AppColors.button.withValues(alpha: 0.2),
              backgroundImage: widget.otherUser.avatar != null
                  ? NetworkImage('$imageUrl${widget.otherUser.avatar}')
                  : null,
              child: widget.otherUser.avatar == null
                  ? Text(
                      widget.otherUser.name[0].toUpperCase(),
                      style: TextStyle(
                        color: AppColors.button,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            )
          else if (!isSent)
            SizedBox(width: 32.w),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isSent
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSent
                        ? LinearGradient(
                            colors: [AppColors.button, AppColors.c28B446],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isSent ? null : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.r),
                      topRight: Radius.circular(18.r),
                      bottomLeft: isSent
                          ? Radius.circular(18.r)
                          : Radius.circular(4.r),
                      bottomRight: isSent
                          ? Radius.circular(4.r)
                          : Radius.circular(18.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.message ?? '',
                    style: TextStyle(
                      color: isSent ? Colors.white : Colors.black87,
                      fontSize: 15.sp,
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: TextStyle(fontSize: 11.sp, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: _translate(
                      'Type a message...',
                      'একটি বার্তা লিখুন...',
                    ),
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    // Optional: Send typing indicator
                  },
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.button, AppColors.c28B446],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.button.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

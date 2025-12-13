import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../networks/endpoints.dart';
import '../../../../constants/app_constants.dart';
import '../data/chat_service.dart';
import '../models/chat_model.dart';
import 'chat_screen.dart';
import 'search_user_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  List<ChatUser> _users = [];
  bool _isLoading = true;
  String _currentLanguage = 'en';
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _loadLanguage();
    _loadChats();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadLanguage() {
    final lang = GetStorage().read(kKeyLanguage) ?? 'en';
    setState(() => _currentLanguage = lang);
  }

  String _translate(String en, String bn) {
    return _currentLanguage == 'bn' ? bn : en;
  }

  Future<void> _loadChats() async {
    setState(() => _isLoading = true);
    final result = await ChatService.getChatList();
    if (mounted) {
      if (result['success'] == true) {
        setState(() {
          _users = List<ChatUser>.from(result['data']);
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _translate('Chats', 'চ্যাট'),
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchUserScreen()),
                      );
                    },
                    child: _buildHeaderIcon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.button,
                    strokeWidth: 2.5,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    _translate('Loading chats...', 'চ্যাট লোড হচ্ছে...'),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ],
              ),
            )
          : _users.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadChats,
              color: AppColors.button,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return _buildChatTile(_users[index], index);
                },
              ),
            ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      width: 36.w,
      height: 36.w,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20.sp, color: Colors.grey[700]),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 60.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            _translate('No chats yet', 'এখনও কোন চ্যাট নেই'),
            style: TextStyle(
              fontSize: 20.sp,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _translate('Start a new conversation', 'নতুন কথোপকথন শুরু করুন'),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(ChatUser user, int index) {
    final hasUnread = (user.unreadCount ?? 0) > 0;
    final isOnline = user.isOnline ?? false;

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(otherUser: user)),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[100]!, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                // Avatar with status
                Stack(
                  children: [
                    Hero(
                      tag: 'avatar_${user.id}',
                      child: Container(
                        width: 56.w,
                        height: 56.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: user.avatar == null
                              ? LinearGradient(
                                  colors: [
                                    AppColors.button.withOpacity(0.8),
                                    AppColors.c28B446.withOpacity(0.8),
                                  ],
                                )
                              : null,
                        ),
                        child: user.avatar != null
                            ? ClipOval(
                                child: Image.network(
                                  '$imageUrl${user.avatar}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      _buildAvatarFallback(user),
                                ),
                              )
                            : _buildAvatarFallback(user),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 16.w,
                          height: 16.w,
                          decoration: BoxDecoration(
                            color: Color(0xFF00D856),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 12.w),
                // Message content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              user.storeName ?? user.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          if (user.lastMessageTime != null)
                            Text(
                              _formatTime(user.lastMessageTime!),
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: hasUnread
                                    ? AppColors.button
                                    : Colors.grey[500],
                                fontWeight: hasUnread
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.lastMessage ??
                                  _translate(
                                    'Tap to start chatting',
                                    'চ্যাট শুরু করতে ট্যাপ করুন',
                                  ),
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: hasUnread
                                    ? Colors.black87
                                    : Colors.grey[600],
                                fontWeight: hasUnread
                                    ? FontWeight.w500
                                    : FontWeight.normal,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (hasUnread) ...[
                            SizedBox(width: 8.w),
                            Container(
                              constraints: BoxConstraints(minWidth: 20.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.button,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                '${user.unreadCount}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarFallback(ChatUser user) {
    return Center(
      child: Text(
        user.name[0].toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24.sp,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return TimeOfDay.fromDateTime(time).format(context);
    } else if (difference.inDays == 1) {
      return _translate('Yesterday', 'গতকাল');
    } else if (difference.inDays < 7) {
      final weekdays = _translate(
        ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].join(','),
        ['সোম', 'মঙ্গল', 'বুধ', 'বৃহ', 'শুক্র', 'শনি', 'রবি'].join(','),
      ).split(',');
      return weekdays[time.weekday - 1];
    } else {
      return '${time.day}/${time.month}/${time.year.toString().substring(2)}';
    }
  }
}

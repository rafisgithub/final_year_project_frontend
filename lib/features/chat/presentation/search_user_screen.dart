import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../networks/endpoints.dart';
import '../../../../constants/app_constants.dart';
import '../data/chat_service.dart';
import '../models/chat_model.dart';
import 'chat_screen.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({super.key});

  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatUser> _searchResults = [];
  bool _isLoading = false;
  String _error = '';
  String _currentLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadLanguage() {
    final lang = GetStorage().read(kKeyLanguage) ?? 'en';
    setState(() => _currentLanguage = lang);
  }

  String _translate(String en, String bn) {
    return _currentLanguage == 'bn' ? bn : en;
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _error = '';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = '';
    });

    print('🔍 [Search] Searching for: $query');
    final result = await ChatService.searchUsers(query);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (result['success'] == true) {
          _searchResults = List<ChatUser>.from(result['data']);
          print('✅ [Search] Found ${_searchResults.length} users');
        } else {
          _error =
              result['message'] ??
              _translate('Search failed', 'অনুসন্ধান ব্যর্থ');
          _searchResults = [];
          print('❌ [Search] Error: $_error');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: _translate('Search users...', 'ব্যবহারকারী খুঁজুন...'),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16.sp),
          ),
          style: TextStyle(fontSize: 16.sp, color: Colors.black87),
          onChanged: (value) {
            // Debounce search
            Future.delayed(Duration(milliseconds: 500), () {
              if (_searchController.text == value) {
                _performSearch(value);
              }
            });
          },
          onSubmitted: _performSearch,
          textInputAction: TextInputAction.search,
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.grey[600]),
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchResults = [];
                  _error = '';
                });
              },
            ),
        ],
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
                    _translate('Searching...', 'খুঁজছি...'),
                    style: TextStyle(color: Colors.grey[600], fontSize: 14.sp),
                  ),
                ],
              ),
            )
          : _error.isNotEmpty
          ? _buildErrorState()
          : _searchResults.isEmpty
          ? _buildEmptyState()
          : _buildSearchResults(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_rounded,
              size: 50.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            _searchController.text.isEmpty
                ? _translate('Search for users', 'ব্যবহারকারী খুঁজুন')
                : _translate('No users found', 'কোন ব্যবহারকারী পাওয়া যায়নি'),
            style: TextStyle(
              fontSize: 18.sp,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            _translate('Try searching by name', 'নাম দিয়ে খুঁজে দেখুন'),
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 60.sp, color: Colors.red[300]),
          SizedBox(height: 16.h),
          Text(
            _error,
            style: TextStyle(color: Colors.red[700], fontSize: 16.sp),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => _performSearch(_searchController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.button,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              _translate('Try Again', 'আবার চেষ্টা করুন'),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final user = _searchResults[index];
        return _buildUserTile(user);
      },
    );
  }

  Widget _buildUserTile(ChatUser user) {
    final isOnline = user.isOnline ?? false;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          print('📱 [Search] Opening chat with: ${user.name}');
          Navigator.pushReplacement(
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
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 52.w,
                    height: 52.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: user.avatar == null
                          ? LinearGradient(
                              colors: [
                                AppColors.button.withValues(alpha: 0.8),
                                AppColors.c28B446.withValues(alpha: 0.8),
                              ],
                            )
                          : null,
                    ),
                    child: user.avatar != null
                        ? ClipOval(
                            child: Image.network(
                              '$imageUrl${user.avatar}',
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Center(
                                child: Text(
                                  user.name[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                              user.name[0].toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                  ),
                  if (isOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14.w,
                        height: 14.w,
                        decoration: BoxDecoration(
                          color: Color(0xFF00D856),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: 12.w),
              // User info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: user.role == 'seller'
                                ? AppColors.button.withValues(alpha: 0.1)
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            (user.role ?? 'user').toUpperCase(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: user.role == 'seller'
                                  ? AppColors.button
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                        if (user.lastMessage != null) ...[
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              '• ${user.lastMessage}',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey[500],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chat_bubble_outline,
                color: AppColors.button,
                size: 22.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:final_year_project_frontend/gen/colors.gen.dart';
import 'package:final_year_project_frontend/networks/auth_service.dart';
import 'package:final_year_project_frontend/networks/profile_service.dart';
import 'package:final_year_project_frontend/networks/endpoints.dart';
import 'package:final_year_project_frontend/helpers/all_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Create a GlobalKey to access the ScaffoldState
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  Map<String, dynamic>? _profileData;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final result = await ProfileService.getProfile();
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _profileData = result['data'];
        }
        _isLoadingProfile = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,  // Assign the key to the Scaffold
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children:  <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.button,
                ),
                child: _isLoadingProfile
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 30.r,
                            backgroundColor: Colors.white,
                            backgroundImage: _profileData?['avatar'] != null
                                ? NetworkImage('${imageUrl}${_profileData!['avatar']}')
                                : null,
                            child: _profileData?['avatar'] == null
                                ? Icon(
                                    Icons.person,
                                    size: 35.sp,
                                    color: AppColors.button,
                                  )
                                : null,
                          ),
                          SizedBox(height: 12.h),
                          // Name
                          Text(
                            _profileData?['name'] ?? 'User Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          // Email
                          Text(
                            _profileData?['email'] ?? 'user@email.com',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
              ),

              ListTile(
                leading: Icon(Icons.home, color: AppColors.button),
                title: Text('Home'),
              ),
              ListTile(
                leading: Icon(Icons.swap_horiz, color: AppColors.button),
                title: Text('Switch Role'),
                onTap: () {
                  // Handle switch role action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.language, color: AppColors.button),
                title: Text('Change Language'),
                onTap: () {
                  // Handle change language action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: AppColors.button),
                title: Text('Settings'),
              ),
              SizedBox(height: 250),
              ListTile(
                leading: Icon(Icons.logout, color: AppColors.button),
                title: Text('Logout'),
                onTap: () async {
                  // Show confirmation dialog
                  final shouldLogout = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Logout'),
                      content: Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text('Logout', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    // Show loading dialog
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(),
                      ),
                    );

                    // Call sign out API
                    final result = await AuthService.signOut();

                    if (mounted) {
                      // Close loading dialog
                      Navigator.pop(context);

                      if (result['success'] == true) {
                        // Navigate to sign in screen and clear navigation stack
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.signinScreen,
                          (route) => false,
                        );
                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'] ?? 'Logout failed'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.yellow),
          onPressed: () {
            // Use the GlobalKey to open the drawer
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: Text(
          'Home',
          style: TextStyle(fontSize: 24, color: Colors.yellow),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

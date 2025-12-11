# Google Authentication - Pure Google Sign-In (No Firebase)

This implementation uses **pure Google Sign-In** without Firebase, sending tokens directly to your Django backend for JWT authentication.

## ✅ What's Changed

1. **Removed Firebase dependencies** (`firebase_core`, `firebase_auth`)
2. **Created `TokenStorage`** - Manages JWT tokens locally using GetStorage
3. **Updated `GoogleAuthService`** - Uses pure Google Sign-In, sends `id_token` and `access_token` to Django
4. **Added `AuthInterceptor`** - Automatically refreshes JWT tokens on 401 errors
5. **Removed hardcoded OAuth Client ID** - No longer needed for Android

## 📁 New Files Created

- `lib/networks/token_storage.dart` - JWT token management
- `lib/networks/auth_interceptor.dart` - Automatic token refresh
- `lib/networks/google_auth_service.dart` - Updated (pure Google Sign-In)

## 🔧 How to Use

### 1. Sign In with Google

```dart
import 'package:final_year_project_frontend/networks/google_auth_service.dart';

// In your sign-in button onPressed
Future<void> handleGoogleSignIn() async {
  final result = await GoogleAuthService.signInWithGoogle();
  
  if (result['success'] == true) {
    // Success! User is authenticated
    print('✅ Signed in: ${result['data']}');
    
    // Navigate to home screen
    NavigationService.navigateToReplacement('/home');
  } else {
    // Failed
    print('❌ Sign in failed: ${result['message']}');
    
    // Show error to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result['message'])),
    );
  }
}
```

### 2. Check Authentication Status

```dart
// Check if user is logged in
final isLoggedIn = await GoogleAuthService.isAuthenticated();

if (isLoggedIn) {
  // User is authenticated
  final userData = await GoogleAuthService.getCurrentUser();
  print('User: ${userData?['name']}');
  print('Email: ${userData?['email']}');
}
```

### 3. Sign Out

```dart
// Sign out button
Future<void> handleSignOut() async {
  await GoogleAuthService.signOut();
  
  // Navigate to login screen
  NavigationService.navigateToReplacement('/login');
}
```

### 4. Access User Data

```dart
// Get current user data from local storage
final userData = await TokenStorage.getUserData();

if (userData != null) {
  final name = userData['name'];
  final email = userData['email'];
  final photoUrl = userData['photoUrl'];
  final role = userData['role']; // From Django backend
}
```

### 5. Manual Token Refresh (Optional)

```dart
// Refresh token manually (usually handled automatically by AuthInterceptor)
final refreshed = await GoogleAuthService.refreshToken();

if (refreshed) {
  print('✅ Token refreshed');
} else {
  print('❌ Token refresh failed - user needs to re-login');
  await GoogleAuthService.signOut();
}
```

## 🔐 Django Backend Requirements

Your Django backend should accept the following payload at the `/google-auth/` endpoint:

### Request
```json
{
  "access_token": "ya29.a0AfB_byD..."
}
```

### Response (Success)
```json
{
  "success": true,
  "message": "Signin successful.",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "id": 10,
    "email": "user@gmail.com",
    "role": "seller",
    "is_seller": true
  }
}
```

### Response (Error)
```json
{
  "success": false,
  "message": "Invalid Google token"
}
```

## 🔄 Token Refresh Endpoint

Your Django backend should also have a token refresh endpoint (e.g., `/token/refresh/`):

### Request
```json
{
  "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc..."
}
```

### Response
```json
{
  "access": "eyJ0eXAiOiJKV1QiLCJhbGc..."  // New access token
}
```

**Note:** Update the endpoint in `google_auth_service.dart` line 169:
```dart
final response = await postHttpNoAuth(
  'token/refresh/', // Change this to match your Django endpoint
  {'refresh': refreshToken},
);
```

## 🚀 Optional: Add Auth Interceptor to Dio

To enable automatic token refresh on 401 errors, add the `AuthInterceptor` to your Dio instance:

```dart
// In lib/networks/dio/dio.dart

import '../auth_interceptor.dart';

void create() {
  BaseOptions options = BaseOptions(
    baseUrl: url,
    connectTimeout: const Duration(milliseconds: 100000),
    receiveTimeout: const Duration(milliseconds: 100000),
    headers: {
      NetworkConstants.ACCEPT: NetworkConstants.ACCEPT_TYPE,
      NetworkConstants.APP_KEY: NetworkConstants.APP_KEY_VALUE,
    },
  );
  dio = Dio(options)
    ..interceptors.add(Logger())
    ..interceptors.add(AuthInterceptor(dio)); // Add this line
}
```

## ❌ No Firebase Configuration Needed!

Since we're using pure Google Sign-In:
- ✅ No `google-services.json` needed
- ✅ No SHA-1 certificate configuration
- ✅ No Firebase Console setup
- ✅ No Firebase initialization in `main.dart`

The only thing Google Sign-In needs is the **Google Play Services** on the Android device (which is standard on all Android phones).

## 🐛 Troubleshooting

### Error: "PlatformException(sign_in_failed, ApiException: 10)"

This error should now be **GONE** because:
1. We removed the hardcoded `clientId` (not needed for Android)
2. We removed Firebase dependencies
3. Google Sign-In will use the default Android configuration

### If you still get errors:

1. **Clear app data and reinstall:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Make sure Google Play Services is installed** on your device/emulator

3. **Check your Django backend** is returning the correct response format

## 📝 Example: Complete Sign-In Screen

```dart
import 'package:flutter/material.dart';
import 'package:final_year_project_frontend/networks/google_auth_service.dart';
import 'package:final_year_project_frontend/helpers/navigation_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final result = await GoogleAuthService.signInWithGoogle();

      if (result['success'] == true) {
        // Success!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome ${result['data']['name']}!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to home
        NavigationService.navigateToReplacement('/home');
      } else {
        // Failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                icon: Icon(Icons.login),
                label: Text('Continue with Google'),
              ),
      ),
    );
  }
}
```

## ✅ Summary

You now have a **clean, Firebase-free Google Sign-In** implementation that:
- ✅ Uses pure Google Sign-In
- ✅ Sends tokens to your Django backend
- ✅ Receives and stores JWT tokens
- ✅ Automatically refreshes tokens on expiry
- ✅ No Firebase configuration headaches!

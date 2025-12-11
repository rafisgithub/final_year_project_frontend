# Google Auth Flow - Complete Example

This document shows the complete Google Sign-In flow with your actual backend response format.

## 🔄 Complete Authentication Flow

### **Step 1: User Signs In**

User taps "Sign in with Google" button in your Flutter app.

### **Step 2: Flutter Console Output**

```
========================================
🔑 STARTING GOOGLE SIGN-IN
========================================

========================================
✅ GOOGLE SIGN-IN SUCCESS
========================================
User Email: newus@gmail.com
User Display Name: New User
User ID: 123456789012345678901
Photo URL: https://lh3.googleusercontent.com/a/...
========================================
📋 FULL ACCESS TOKEN (Copy for Postman):
========================================
ya29.a0AfB_byBxCvDeFgHiJkLmNoPqRsTuVwXyZ1234567890abcdefghijklmnopqrstuvwxyz...
========================================
Token Length: 187 characters
First 50 chars: ya29.a0AfB_byBxCvDeFgHiJkLmNoPqRsTuVwXyZ12345...
========================================

========================================
🌐 SENDING TO DJANGO BACKEND
========================================
Endpoint: google-auth/
Method: POST
Payload: {"access_token": "ya29.a0AfB_byBxCvDeFgHiJkLmNoPqRsTuVwXyZ12345..."}
========================================

========================================
📥 BACKEND RESPONSE
========================================
Status Code: 200
Response Data: {
  success: true, 
  message: Signin successful., 
  data: {
    refresh_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..., 
    access_token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..., 
    id: 10, 
    role: seller, 
    is_seller: true, 
    email: newus@gmail.com
  }
}
========================================

========================================
✅ AUTHENTICATION SUCCESSFUL
========================================
User ID: 10
Email: newus@gmail.com
Role: seller
Is Seller: true
JWT Access Token saved (187 chars)
JWT Refresh Token saved (187 chars)
User data saved to local storage
========================================
```

### **Step 3: Data Stored Locally**

The following data is saved in local storage using `TokenStorage`:

```dart
{
  "id": "10",
  "email": "newus@gmail.com",
  "name": "New User",
  "photoUrl": "https://lh3.googleusercontent.com/a/...",
  "googleId": "123456789012345678901",
  "role": "seller",
  "is_seller": true,
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### **Step 4: JWT Token Added to All API Calls**

All subsequent API calls automatically include the JWT token:

```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 📊 Data Mapping

| Source | Field | Stored As | Value Example |
|--------|-------|-----------|---------------|
| Django Backend | `id` | `id` | `"10"` |
| Django Backend | `email` | `email` | `"newus@gmail.com"` |
| Google Account | `displayName` | `name` | `"New User"` |
| Google Account | `photoUrl` | `photoUrl` | `"https://..."` |
| Google Account | `id` | `googleId` | `"123456..."` |
| Django Backend | `role` | `role` | `"seller"` |
| Django Backend | `is_seller` | `is_seller` | `true` |
| Django Backend | `access_token` | Stored separately | JWT token |
| Django Backend | `refresh_token` | Stored separately | JWT token |

## 🔍 Accessing User Data in Your App

### **Get Current User**

```dart
final userData = await GoogleAuthService.getCurrentUser();

if (userData != null) {
  final userId = userData['id'];              // "10"
  final email = userData['email'];            // "newus@gmail.com"
  final name = userData['name'];              // "New User"
  final role = userData['role'];              // "seller"
  final isSeller = userData['is_seller'];     // true
  final photoUrl = userData['photoUrl'];      // "https://..."
}
```

### **Check if User is Seller**

```dart
final userData = await TokenStorage.getUserData();
final isSeller = userData?['is_seller'] ?? false;

if (isSeller) {
  // Show seller dashboard
  NavigationService.navigateTo('/seller-dashboard');
} else {
  // Show buyer home
  NavigationService.navigateTo('/home');
}
```

### **Get User Role**

```dart
final userData = await TokenStorage.getUserData();
final role = userData?['role'] ?? 'buyer';

switch (role) {
  case 'seller':
    // Seller-specific UI
    break;
  case 'buyer':
    // Buyer-specific UI
    break;
  default:
    // Default UI
}
```

## 🔐 Token Management

### **Access Token**

- Stored in: `TokenStorage`
- Used for: All authenticated API calls
- Automatically added to: Request headers as `Authorization: Bearer <token>`
- Expires: Based on Django JWT settings (typically 1 hour)

### **Refresh Token**

- Stored in: `TokenStorage`
- Used for: Getting new access tokens when they expire
- Endpoint: `/token/refresh/` (update in `google_auth_service.dart` if different)
- Automatically refreshed: When API returns 401 (if using `AuthInterceptor`)

## 🧪 Testing Checklist

- [ ] User can sign in with Google
- [ ] Access token is printed in console
- [ ] Backend returns success response
- [ ] JWT tokens are saved locally
- [ ] User data (id, email, role, is_seller) is saved
- [ ] Dio is updated with JWT token
- [ ] Subsequent API calls include Authorization header
- [ ] User can access protected routes
- [ ] Seller users see seller-specific features
- [ ] Token refresh works on 401 errors

## 🎯 Next Steps

1. **Test the complete flow:**
   ```bash
   flutter run
   ```

2. **Sign in and verify console output** matches the example above

3. **Check that user data is accessible:**
   ```dart
   final user = await GoogleAuthService.getCurrentUser();
   print('Logged in as: ${user?['email']} (${user?['role']})');
   ```

4. **Verify protected API calls work:**
   ```dart
   final response = await getHttp('profile-get/');
   // Should include Authorization header automatically
   ```

5. **Test role-based navigation:**
   ```dart
   if (user?['is_seller'] == true) {
     // Navigate to seller dashboard
   } else {
     // Navigate to buyer home
   }
   ```

## ✅ Success Indicators

Your Google Auth is working correctly if:

1. ✅ Console shows "AUTHENTICATION SUCCESSFUL"
2. ✅ User ID, email, role, and is_seller are printed
3. ✅ JWT tokens are saved (both access and refresh)
4. ✅ `await GoogleAuthService.isAuthenticated()` returns `true`
5. ✅ `await GoogleAuthService.getCurrentUser()` returns user data
6. ✅ API calls include `Authorization: Bearer <token>` header
7. ✅ Protected endpoints return data (not 401 errors)

You're all set! 🚀

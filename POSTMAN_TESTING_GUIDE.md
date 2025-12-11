# Testing Google Auth with Postman

This guide shows you how to test your Django Google Auth endpoint using Postman with a real access token from your Flutter app.

## 🔧 Step 1: Get the Access Token from Flutter

1. **Run your Flutter app:**
   ```bash
   flutter run
   ```

2. **Tap "Sign in with Google"** in your app

3. **Check the console output** - you'll see something like this:
   ```
   ========================================
   ✅ GOOGLE SIGN-IN SUCCESS
   ========================================
   User Email: user@example.com
   User Display Name: John Doe
   User ID: 123456789
   Photo URL: https://...
   ========================================
   📋 FULL ACCESS TOKEN (Copy for Postman):
   ========================================
   ya29.a0AfB_byDxxx...very_long_token...xxxyyy
   ========================================
   Token Length: 187 characters
   First 50 chars: ya29.a0AfB_byDxxx...
   ========================================
   ```

4. **Copy the full access token** (the long string between the separator lines)

## 📮 Step 2: Test in Postman

### **Request Configuration:**

**Method:** `POST`

**URL:** `http://172.16.200.94:8000/api/google-auth/`

**Headers:**
```
Content-Type: application/json
```

**Body (raw JSON):**
```json
{
  "access_token": "ya29.a0AfB_byDxxx...paste_your_full_token_here...xxxyyy"
}
```

### **Expected Response (Success):**

```json
{
  "success": true,
  "message": "Authentication successful",
  "data": {
    "access": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "refresh": "eyJ0eXAiOiJKV1QiLCJhbGc...",
    "id": 123,
    "email": "user@example.com",
    "name": "John Doe",
    "role": "buyer",
    "is_seller": false
  }
}
```

### **Expected Response (Error):**

```json
{
  "success": false,
  "message": "Invalid Google token"
}
```

## 🎯 Postman Collection Example

Here's a complete Postman request you can import:

```json
{
  "info": {
    "name": "Google Auth Test",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Google Sign-In",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          }
        ],
        "body": {
          "mode": "raw",
          "raw": "{\n  \"access_token\": \"{{GOOGLE_ACCESS_TOKEN}}\"\n}"
        },
        "url": {
          "raw": "http://172.16.200.94:8000/api/google-auth/",
          "protocol": "http",
          "host": ["172", "16", "200", "94"],
          "port": "8000",
          "path": ["api", "google-auth", ""]
        }
      }
    }
  ]
}
```

## ⚠️ Important Notes

### **Token Expiration**
- Google access tokens typically expire after **1 hour**
- If you get "Invalid token" error, sign in again to get a fresh token
- Each time you sign in, you'll get a new access token

### **Token Format**
- Access tokens always start with `ya29.`
- They are usually 150-250 characters long
- They contain alphanumeric characters, dots, hyphens, and underscores

### **Security Warning**
- ⚠️ **Never commit access tokens to Git**
- ⚠️ **Never share access tokens publicly**
- ⚠️ **Tokens grant access to user's Google account**
- ✅ Only use for testing in development
- ✅ Tokens expire automatically after 1 hour

## 🐛 Troubleshooting

### **"Invalid token" Error**

**Possible causes:**
1. Token has expired (get a fresh one)
2. Token was copied incorrectly (check for extra spaces/newlines)
3. Django backend can't verify the token (check client ID configuration)

**Solution:**
- Sign in again in the Flutter app
- Copy the new token carefully
- Make sure to copy the ENTIRE token (no truncation)

### **"Connection refused" Error**

**Possible causes:**
1. Django server is not running
2. Wrong IP address or port
3. Firewall blocking the connection

**Solution:**
```bash
# Make sure Django is running
python manage.py runserver 0.0.0.0:8000

# Check the IP address matches your Django server
# Update the URL in Postman if needed
```

### **Token Not Printing in Console**

**Possible causes:**
1. App is running in release mode
2. Debug mode is disabled

**Solution:**
- Make sure you're running in debug mode: `flutter run`
- Check that `kDebugMode` is true

## 📝 Quick Testing Checklist

- [ ] Flutter app is running
- [ ] Tapped "Sign in with Google"
- [ ] Saw the full access token in console
- [ ] Copied the ENTIRE token (no spaces/newlines)
- [ ] Django server is running
- [ ] Postman request URL is correct
- [ ] Content-Type header is set to `application/json`
- [ ] Token is pasted in the request body
- [ ] Sent the POST request
- [ ] Received a response from Django

## 🎉 Success Indicators

If everything works correctly, you should see:

1. **In Flutter Console:**
   ```
   ✅ AUTHENTICATION SUCCESSFUL
   JWT Access Token saved
   User data saved to local storage
   ```

2. **In Postman:**
   ```json
   {
     "success": true,
     "data": { ... }
   }
   ```

3. **In Django Logs:**
   ```
   [INFO] Google token verified successfully
   [INFO] User authenticated: user@example.com
   ```

Now you can test your Google Auth endpoint independently! 🚀

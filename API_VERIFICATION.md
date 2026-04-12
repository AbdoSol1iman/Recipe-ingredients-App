# API Verification Checklist for APK Build

## ✅ Build Status
- [x] APK successfully built: `build/app/outputs/flutter-apk/app-release.apk` (52.6MB)
- [x] Debug APK also available: `build/app/outputs/flutter-apk/app-debug.apk`

## ✅ Android Configuration
- [x] `AndroidManifest.xml` includes `<uses-permission android:name="android.permission.INTERNET"/>`
  - This permission is **required** for API calls
- [x] Application configured with proper Android SDK settings
- [x] Network access enabled in build configuration

## ✅ API Configuration (TheMealDB - No API Key Required)
- [x] Base URL: `https://www.themealdb.com/api/json/v1/1`
- [x] No RapidAPI dependency - public API endpoints work without authentication
- [x] Headers only include `Content-Type: application/json`
- [x] Endpoints configured:
  - `searchPath`: `/search.php` - Search by meal name
  - `lookupPath`: `/lookup.php` - Get meal details by ID
  - `randomPath`: `/random.php` - Get random meals
  - `filterPath`: `/filter.php` - Filter by category or area

## ✅ API Service Layer
- [x] `RecipeService` properly implements all API calls
- [x] Error handling with `AppException` and `_throwIfError()`
- [x] Response parsing with `_extractMeals()` helper
- [x] HTTP client properly configured with `http` package

## ✅ Network Dependency
- [x] `http: ^1.2.0` included in `pubspec.yaml`
- [x] No hardcoded API keys in code (uses TheMealDB public API)
- [x] `.env` file not required for API calls

## How to Test API in Built APK

### Option 1: Install and Run on Android Device/Emulator
```bash
# Install release APK
adb install -r build/app/outputs/flutter-apk/app-release.apk

# Or install debug APK for testing
adb install -r build/app/outputs/flutter-apk/app-debug.apk

# Open app and navigate through:
# 1. Home screen → View Popular & Recommended recipes
# 2. Search screen → Search for any meal (e.g., "chicken")
# 3. Recipe detail → Open any recipe to see ingredients/instructions
# 4. Check Logcat for any API errors
```

### Option 2: Use Android Studio/AVD
```bash
# Open Android Studio → Virtual Device Manager
# Create/Start an Android emulator
# Install APK: adb install build/app/outputs/flutter-apk/app-release.apk
```

### Option 3: Check API Manually
```bash
# Test TheMealDB API directly
curl -X GET "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken"
curl -X GET "https://www.themealdb.com/api/json/v1/1/random.php"
curl -X GET "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood"
```

## Debugging Network Issues
If API calls fail in the APK:

1. **Check network permission**: Verify `INTERNET` permission is in AndroidManifest.xml ✅
2. **Check logcat**: Run `adb logcat | grep flutter` while using the app
3. **Check API connectivity**: Test endpoints manually via curl
4. **Verify SSL/TLS**: TheMealDB uses HTTPS (ensure device has updated certificates)
5. **Check firewall**: Ensure device can reach external URLs

## Expected Behavior
- ✅ Splash screen loads in 2 seconds
- ✅ Home screen loads popular & recommended recipes from API
- ✅ Search screen performs real-time recipe searches
- ✅ Recipe detail screen displays ingredients & instructions
- ✅ All images load from `strMealThumb` URLs
- ✅ No subscription/authentication errors (TheMealDB is free)

---
**Build Date**: April 2, 2026  
**API**: TheMealDB v1.1 (Public)  
**Status**: Ready for Testing ✅


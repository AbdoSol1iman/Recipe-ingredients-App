# Wasfty APK Setup & Testing Guide

## Build Information
- **Project**: Wasfty (Recipe Discovery App)
- **API**: TheMealDB (Free, no API key required)
- **Build Date**: April 2, 2026
- **APK Location**: `build/app/outputs/flutter-apk/`

---

## Built Artifacts

### Release Build (Production)
```
app-release.apk (52.6MB)
```
- Optimized for production
- Tree-shaken assets for reduced size
- Use this for final testing and distribution

### Debug Build (Development)
```
app-debug.apk
```
- Includes debug symbols
- Useful for troubleshooting
- Slower but easier to debug

---

## Installation on Android Device/Emulator

### Prerequisites
- Android device or AVD (Android Virtual Device) emulator
- Android SDK Platform Tools (`adb`)
- USB debugging enabled (for physical devices)

### Install via ADB
```bash
cd /home/dev911/AndroidStudioProjects/wasftk

# For release APK
adb install -r build/app/outputs/flutter-apk/app-release.apk

# For debug APK (if preferred)
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### Install via Android Studio
1. Open **Android Studio**
2. Go to **Build → Select Build Variant** and choose `release` or `debug`
3. Run the APK directly from the IDE

---

## API Endpoints & Testing

### TheMealDB API (Public, No Authentication Required)

All endpoints are hosted at: `https://www.themealdb.com/api/json/v1/1`

#### 1. Search by Meal Name
```bash
curl "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken"
```
**App Usage**: Search Screen - type "chicken"

#### 2. Lookup Meal by ID
```bash
curl "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"
```
**App Usage**: Recipe Detail Screen - displays ingredients, instructions, nutrition

#### 3. Random Meal
```bash
curl "https://www.themealdb.com/api/json/v1/1/random.php"
```
**App Usage**: Home Screen - Recommended section

#### 4. Filter by Category
```bash
curl "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood"
```
**App Usage**: Home Screen - Category chips (Beef, Breakfast, Dessert, etc.)

---

## App Walkthrough

### 1. Splash Screen
- Shows "Wasfty" logo for 2 seconds
- Automatically navigates to Onboarding (first time) or Home (returning users)

### 2. Onboarding Screen
- 3 slides introducing the app
- "Get Started" button saves completion and navigates to Home
- Skipped on subsequent app launches

### 3. Home Screen
- **Popular Recipes** section: horizontal scroll list
  - Fetches via `filter.php?c=[category]` or `complexSearch`
- **Category Chips**: All, Main Course, Breakfast, Dessert, Salad, Soup
  - Filters popular recipes by category
- **Recommended** section: vertical list
  - Fetches via `random.php` endpoint
- **Search Bar**: tap to navigate to Search screen

### 4. Search Screen
- **Real-time Search**: type meal name (e.g., "pasta")
  - Debounces for 500ms before API call
  - Fetches via `search.php?s=[query]`
- **Autocomplete Suggestions**: shows matching meal names
- **Filter Button**: advanced filters (Cuisine, Diet, Max Ready Time)
- **Results Grid**: 2-column grid of recipe cards

### 5. Recipe Detail Screen
- **Hero Image**: large recipe photo with back button
- **Save/Bookmark Icon**: click to save locally
- **Tabs**:
  - **Ingredients**: list of ingredients with measurements
  - **Instructions**: numbered cooking steps
  - **Nutrition**: macro breakdown (if available)
- **Similar Recipes**: horizontal scroll list of related recipes
- **Back Button**: returns to previous screen

### 6. Saved Screen
- **Grid of Bookmarked Recipes**: 2-column layout
- **Swipe to Delete**: drag left to remove from saved
- **Tap to View**: click card to open recipe detail
- **Empty State**: "No saved recipes yet" when empty

### 7. Profile Screen
- **User Stats**: count of saved recipes
- **Settings**:
  - Dietary preferences
  - App notifications (optional)
  - About section

---

## Expected Network Behavior

### Success Indicators ✅
1. **Home Screen Loads**: Popular & Recommended recipes appear
2. **Search Works**: Type "pasta" and see results instantly
3. **Images Load**: All recipe images display properly
4. **Detail View**: Click recipe → See full ingredients & instructions
5. **Save Feature**: Bookmark icon toggles on/off
6. **Navigation**: Back button returns to previous screen

### Error Handling ✅
1. **Network Unavailable**: SnackBar message "Failed to load recipes"
2. **Empty Results**: "No recipes found" with icon
3. **API Error**: Retry button on error screen
4. **Missing Image**: Broken image icon displayed

---

## Troubleshooting

### Issue: APK Won't Install
```bash
# Clear previous installation
adb uninstall com.example.wasftk

# Reinstall
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Issue: API Calls Failing
**Check 1**: Device has internet permission
```bash
# View manifest
cat android/app/src/main/AndroidManifest.xml | grep INTERNET
# Should show: <uses-permission android:name="android.permission.INTERNET"/>
```

**Check 2**: Device can reach TheMealDB
```bash
# On Android device via adb shell
adb shell
ping www.themealdb.com  # Should succeed

# Or test via curl on your computer
curl -I https://www.themealdb.com/api/json/v1/1/random.php
# Should return: HTTP/1.1 200 OK
```

**Check 3**: Review logcat for errors
```bash
adb logcat | grep flutter
# Look for network or JSON parsing errors
```

### Issue: Recipes Don't Display
1. Wait 2-3 seconds - API calls may be slow on first load
2. Swipe down to refresh on Home screen
3. Check internet connection on device
4. Try searching for a specific meal in Search screen

### Issue: Images Not Loading
- TheMealDB image CDN may be temporarily slow
- Try pulling down to refresh
- Clear app cache: Settings → Apps → Wasftk → Storage → Clear Cache

---

## Debugging Commands

### View App Logs
```bash
adb logcat -s flutter:V
```

### View All Logs
```bash
adb logcat
```

### Stop Logcat
```bash
adb logcat -c
```

### Test API Endpoint Directly
```bash
# From your computer
curl -X GET "https://www.themealdb.com/api/json/v1/1/search.php?s=burger" | python -m json.tool
```

### Check Device State
```bash
adb devices  # List connected devices
adb shell getprop ro.build.version.release  # Android version
adb shell pm get-app-link com.example.wasftk  # App info
```

---

## Performance Notes

- **First Launch**: May take 3-5 seconds to load recipes (API response time)
- **Search Debounce**: 500ms delay before search API call (reduces server load)
- **Image Caching**: Images cached locally using `cached_network_image` package
- **Local Storage**: Saved recipes stored in Hive database (fast, offline-capable)

---

## API Rate Limiting

TheMealDB public API has generous rate limits:
- No strict per-minute limits
- Recommended: max 1-2 requests per second per user
- The app implements debounced search (500ms) to respect limits

---

## Security Notes

- ✅ No API keys hardcoded in app
- ✅ Uses HTTPS for all API calls
- ✅ User data (saved recipes) stored locally
- ✅ No personal information collected or transmitted

---

## Support

For API issues, visit: https://www.themealdb.com/  
For Flutter issues: https://flutter.dev/  
For build issues, check: `build/app/outputs/logs/`

---

**Last Updated**: April 2, 2026  
**Status**: Ready for Production Testing ✅


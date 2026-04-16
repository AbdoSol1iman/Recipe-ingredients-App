<div align="center">

# Wasfty

### A Modern Flutter Recipe Discovery App

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State%20Management-Provider-brightgreen)](https://pub.dev/packages/provider)
[![Routing](https://img.shields.io/badge/Routing-go_router-orange)](https://pub.dev/packages/go_router)

**Discover, search, and save delicious recipes with a clean multi-screen experience.**

[Features](#-key-features) • [Demo](#-demo) • [Installation](#-installation--setup) • [Architecture](#-architecture) • [Screenshots](#-screenshots-gallery)

---

</div>

---

## Hero Banner

<p align="center">
  <img src="docs/images/hero-banner.png" alt="Wasfty Hero Banner" width="900"/>
</p>

<p align="center">
  <em>TODO: Replace with your final hero screenshot/banner before submission.</em>
</p>

---

## Project Story

### The Problem

Many recipe apps are either overloaded with cluttered UI or make it hard to quickly find recipes by preference, time, and dietary needs.

### Why It Matters

A smooth recipe experience helps users:

- Find meals faster
- Plan better based on dietary preferences
- Save favorite recipes for repeat cooking
- Follow clear ingredients and instructions

### Our Solution

**Wasfty** is a Flutter app designed for a complete recipe journey:

- Onboarding and splash flow
- Home feed with categories and recommendations
- Smart search with debounce and filters
- Detailed recipe view (ingredients, instructions, nutrition)
- Local saved recipes and profile preferences

<table align="center">
  <tr>
    <td align="center" width="50%">
      <img src="docs/images/home-screen.png" alt="Home Screen" style="max-width: 280px; width: 100%;"/>
      <br/>
      <sub><em>Home Experience</em></sub>
    </td>
    <td align="center" width="50%">
      <img src="docs/images/recipe-detail-screen.png" alt="Recipe Detail Screen" style="max-width: 280px; width: 100%;"/>
      <br/>
      <sub><em>Recipe Detail Experience</em></sub>
    </td>
  </tr>
</table>

<p align="center">
  <em>TODO: Replace both placeholders with your real app screenshots.</em>
</p>

---

## Key Features

### Mobile App Features

| Feature | Description | Icon |
|---|---|---|
| Splash + Onboarding | First-run onboarding with local persistence | 🚀 |
| Home Feed | Popular + recommended recipe sections | 🍽️ |
| Category Filtering | Filter by recipe type from home chips | 🏷️ |
| Real-time Search | Debounced search and autocomplete suggestions | 🔎 |
| Recipe Details | Ingredients, instructions, and nutrition tabs | 📖 |
| Saved Recipes | Bookmark recipes locally with Hive | 🔖 |
| Profile Settings | Dietary preference defaults and app settings | 👤 |

### Technical Highlights

- Provider-based state management
- Clean layered architecture (`core`, `data`, `presentation`, `router`)
- Local storage with Hive + SharedPreferences
- Cached network images + shimmer loading states
- Route transitions using `go_router`

---

## Demo

### Quick Demo

<p align="center">
  <img src="docs/images/onboarding-discover.jpg" alt="Onboarding Screen" width="180" style="margin: 8px;"/>
  <img src="docs/images/login-screen.jpg" alt="Login Screen" width="180" style="margin: 8px;"/>
  <img src="docs/images/search-koshari-screen.jpg" alt="Search Screen" width="180" style="margin: 8px;"/>
  <img src="docs/images/saved-screen.jpg" alt="Saved Screen" width="180" style="margin: 8px;"/>
</p>

**Run locally:**

```zsh
cd /home/dev911/AndroidStudioProjects/wasftk
flutter pub get
flutter run
```

---

## Screenshots Gallery

Latest mobile screenshots used in this README:

### Core Screens

- `docs/images/onboarding-discover.jpg`
- `docs/images/profile-screen.jpg`
- `docs/images/login-screen.jpg`
- `docs/images/search-koshari-screen.jpg`
- `docs/images/saved-screen.jpg`
- `docs/images/login-keyboard-screen.jpg`
- `docs/images/signup-keyboard-screen.jpg`

<p align="center">
  <img src="docs/images/onboarding-discover.jpg" alt="Onboarding" width="180" style="margin: 8px;"/>
  <img src="docs/images/profile-screen.jpg" alt="Profile" width="180" style="margin: 8px;"/>
  <img src="docs/images/login-screen.jpg" alt="Login" width="180" style="margin: 8px;"/>
  <img src="docs/images/search-koshari-screen.jpg" alt="Search" width="180" style="margin: 8px;"/>
  <img src="docs/images/saved-screen.jpg" alt="Saved" width="180" style="margin: 8px;"/>
  <img src="docs/images/login-keyboard-screen.jpg" alt="Login Keyboard" width="180" style="margin: 8px;"/>
  <img src="docs/images/signup-keyboard-screen.jpg" alt="Signup Keyboard" width="180" style="margin: 8px;"/>
</p>

---

## Step-by-Step Walkthrough

### Step 1: Onboarding and Entry

<p align="center">
  <img src="docs/images/onboarding-discover.jpg" alt="Step 1 Onboarding" width="320"/>
</p>

**What happens:**
1. User opens app and sees splash
2. User completes onboarding slides
3. App stores onboarding completion state
4. User is routed to home screen

---

### Step 2: Search and Discover

<p align="center">
  <img src="docs/images/search-koshari-screen.jpg" alt="Step 2 Search" width="320"/>
</p>

**What happens:**
1. User enters search text
2. Debounced request fetches matching recipes
3. Autocomplete suggestions appear
4. Optional filters refine results

---

### Step 3: Open Detail and Save

<p align="center">
  <img src="docs/images/saved-screen.jpg" alt="Step 3 Saved" width="320"/>
</p>

**What happens:**
1. User opens recipe details
2. Views ingredients/instructions/nutrition
3. Saves recipe to local storage
4. Finds saved recipe later in Saved tab

---

## Architecture

### App Architecture Diagram

<p align="center">
  <img src="docs/images/architecture-diagram.png" alt="Wasfty Architecture" width="760"/>
  <br/>
  <em>TODO: Replace with your architecture diagram screenshot.</em>
</p>

### Component Overview

```text
Wasfty (Flutter)
├── core/
│   ├── constants/
│   └── theme/
├── data/
│   ├── models/
│   ├── services/
│   └── repositories/
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
└── router/
```

### Technology Stack

| Layer | Technology |
|---|---|
| UI Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Navigation | go_router |
| Remote API | TheMealDB |
| Networking | http |
| Local DB | Hive |
| Local Preferences | SharedPreferences |
| Image Caching | cached_network_image |
| Loading Skeleton | shimmer |

---

## Repository Structure

```text
wasftk/
├── lib/
│   ├── core/
│   ├── data/
│   ├── presentation/
│   ├── router/
│   └── main.dart
├── test/
├── android/
├── ios/
├── linux/
├── web/
├── windows/
├── pubspec.yaml
└── README.md
```

---

## Installation & Setup

### Prerequisites

- Flutter SDK installed
- Android Studio / VS Code
- Linux build dependencies (if running desktop)

### Steps

```zsh
git clone <your-repository-url>
cd wasftk
flutter pub get
flutter run
```

### Firebase Authentication Setup (Required for Login/Signup)

1. Create a Firebase project and add Android + iOS apps.
2. Enable `Authentication` -> `Sign-in method` -> `Email/Password`.
3. Download and place config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
4. Generate Flutter Firebase options and update app config:

```zsh
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Re-fetch packages and run:

```zsh
flutter pub get
flutter run
```

### Test

```zsh
flutter test
```

---

## Notes for Submission

- Add all missing screenshots into `docs/images/`
- Replace every `TODO` placeholder image before submission
- Keep image names the same as listed to avoid broken links

---

## License

This project is for educational and portfolio use.

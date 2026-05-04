<div align="center">

# Wasfty

**A modern Flutter recipe discovery app** — discover, search, and save recipes with a clean multi-screen experience.

[![Flutter](https://img.shields.io/badge/Flutter-3.41+-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart)](https://dart.dev)
[![State%20Management](https://img.shields.io/badge/State%20Management-Provider-brightgreen)](https://pub.dev/packages/provider)
[![Routing](https://img.shields.io/badge/Routing-go_router-orange)](https://pub.dev/packages/go_router)

</div>

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Demo](#demo)
- [Screenshots](#screenshots)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Firebase Authentication Setup](#firebase-authentication-setup)
- [Testing](#testing)
- [Notes](#notes)
- [License](#license)

## Overview

Many recipe apps feel cluttered or make it difficult to quickly find meals that match a user’s preferences (time, diet, and ingredients).

**Wasfty** focuses on a smooth recipe journey:

- Onboarding + splash flow
- Home feed with categories and recommendations
- Debounced search with optional filters
- Recipe details (ingredients, instructions, nutrition)
- Local saved recipes and profile preferences

## Key Features

### App Features

| Feature | Description |
| --- | --- |
| Splash + Onboarding | First-run onboarding with local persistence |
| Home Feed | Popular and recommended recipes |
| Category Filtering | Filter by recipe type from home chips |
| Real-time Search | Debounced search + autocomplete suggestions |
| Recipe Details | Ingredients, instructions, and nutrition tabs |
| Saved Recipes | Bookmark recipes locally with Hive |
| Profile Settings | Dietary preferences and app settings |

### Technical Highlights

- State management: **Provider**
- Navigation: **go_router**
- Local storage: **Hive** + **SharedPreferences**
- Images: **cached_network_image**
- Loading UI: **shimmer** skeletons

## Demo

> Add a short GIF/video link here (recommended).

Run locally:

```sh
flutter pub get
flutter run
```

## Screenshots

> Place screenshots under `docs/images/`.

### Hero Banner

<p align="center">
  <img src="docs/images/hero-banner.png" alt="Wasfty Hero Banner" width="900" />
</p>

### Core Screens

<p align="center">
  <img src="docs/images/onboarding-discover.jpg" alt="Onboarding" width="180" />
  <img src="docs/images/profile-screen.jpg" alt="Profile" width="180" />
  <img src="docs/images/login-screen.jpg" alt="Login" width="180" />
  <img src="docs/images/search-koshari-screen.jpg" alt="Search" width="180" />
  <img src="docs/images/saved-screen.jpg" alt="Saved" width="180" />
</p>

## Architecture

> If you have an updated diagram, replace the image below.

<p align="center">
  <img src="docs/images/architecture-diagram.png" alt="Wasfty Architecture" width="760" />
</p>

Layered structure:

```text
lib/
├── core/
├── data/
├── presentation/
├── router/
└── main.dart
```

## Tech Stack

| Layer | Technology |
| --- | --- |
| UI Framework | Flutter |
| Language | Dart |
| State Management | Provider |
| Navigation | go_router |
| Remote API | TheMealDB |
| Networking | http |
| Local DB | Hive |
| Preferences | SharedPreferences |
| Image Caching | cached_network_image |
| Loading Skeleton | shimmer |

## Repository Structure

```text
.
├── lib/
├── test/
├── android/
├── ios/
├── linux/
├── web/
├── windows/
├── pubspec.yaml
└── README.md
```

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio or VS Code

### Installation

```sh
git clone <your-repository-url>
cd wasftk
flutter pub get
flutter run
```

## Firebase Authentication Setup

This project uses **Firebase Email/Password** for login/signup.

1. Create a Firebase project and add Android + iOS apps.
2. Enable **Authentication → Sign-in method → Email/Password**.
3. Download and place the config files:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
4. Generate Flutter Firebase options:

```sh
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Fetch packages and run:

```sh
flutter pub get
flutter run
```

## Testing

```sh
flutter test
```

## Notes

- Keep all README images under `docs/images/` to avoid broken links.
- Consider adding:
  - a short demo GIF/video
  - a “Contributing” section if you want external contributions

## License

This project is for educational and portfolio use.

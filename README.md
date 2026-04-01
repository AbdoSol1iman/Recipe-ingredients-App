# Recipely

Recipely is a production-ready Flutter recipe app powered by the free TheMealDB API.

## Features

- Splash and onboarding flow persisted with SharedPreferences
- Home feed with popular and recommended recipes
- Search with debounce, autocomplete, and advanced filters
- Recipe detail with ingredients, instructions, and similar recipes
- Saved recipes persisted locally with Hive
- Profile settings for dietary preferences

## Tech Stack

- Flutter + Dart
- Provider for state management
- go_router for navigation and transitions
- http for API calls
- hive + hive_flutter for local persistence
- shared_preferences for lightweight settings
- cached_network_image for image loading
- shimmer for loading placeholders
- **API: TheMealDB (free, no authentication required)**

## Setup & Run

No API key required! TheMealDB is completely free.

```zsh
flutter pub get
flutter run
```

## Run Tests

```zsh
flutter test
```

## Project Structure

The app uses a layered architecture:

- `lib/core` for constants and theme
- `lib/data` for models, service, and repository
- `lib/presentation` for screens, widgets, and providers
- `lib/router` for route definitions

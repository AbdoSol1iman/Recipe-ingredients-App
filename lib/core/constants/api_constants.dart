
class ApiConstants {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // TheMealDB endpoints (no API key required)
  static const String searchPath = '/search.php';
  static const String lookupPath = '/lookup.php';
  static const String randomPath = '/random.php';
  static const String filterPath = '/filter.php';

  static Map<String, String> get headers {
    return {
      'Content-Type': 'application/json',
    };
  }
}

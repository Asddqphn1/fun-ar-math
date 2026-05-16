import 'package:translator/translator.dart';

class TranslationService {
  static final GoogleTranslator _translator = GoogleTranslator();
  
  // Simple memory cache to avoid redundant API calls
  static final Map<String, String> _cache = {};

  /// Translates Indonesian text to the target language.
  /// If targetLang is 'id' (Indonesian), it just returns the original text.
  static Future<String> translate(String text, String targetLang) async {
    if (targetLang == 'id') return text;
    if (text.trim().isEmpty) return text;

    final cacheKey = '${text.hashCode}_$targetLang';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey]!;
    }

    try {
      final translation = await _translator.translate(text, from: 'id', to: targetLang);
      _cache[cacheKey] = translation.text;
      return translation.text;
    } catch (e) {
      // In case of any network error, fallback to the original text
      print('Translation error: $e');
      return text;
    }
  }
}

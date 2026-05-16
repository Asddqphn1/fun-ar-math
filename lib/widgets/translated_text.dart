import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/language_provider.dart';
import '../core/translation_service.dart';

class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const TranslatedText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.watch<LanguageProvider>().languageCode;
    
    return FutureBuilder<String>(
      future: TranslationService.translate(text, languageCode),
      builder: (context, snapshot) {
        String displayText = snapshot.hasData ? snapshot.data! : text;
        return Text(displayText, style: style, textAlign: textAlign);
      },
    );
  }
}


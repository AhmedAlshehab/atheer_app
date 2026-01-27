import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class ShareUtils {
  static Future<void> shareApp() async {
    const String appLink = 'https://play.google.com/store/apps/details?id=com.atheer.dhikr';
    const String message = '📱 حمل تطبيق "أثير" للأذكار الإسلامية\n\n'
        'تطبيق رائع للذكر والتسبيح بأسلوب أنيق وجميل\n\n'
        '$appLink\n\n'
        '#أثير #Atheer #أذكار #تطبيق_إسلامي';
    
    await Share.share(message);
  }
  
  static Future<void> shareDhikr(String dhikrText, String blessing) async {
    final String message = '$dhikrText\n\n'
        '$blessing\n\n'
        'مشاركة من تطبيق "أثير" للأذكار';
    
    await Share.share(message);
  }
  
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }
}
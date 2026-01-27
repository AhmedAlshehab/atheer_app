import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants/app_constants.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../widgets/glassmorphism_container.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConstants.developerEmail,
    );
    
    if (await canLaunch(emailLaunchUri.toString())) {
      await launch(emailLaunchUri.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('معلومات عنا'),
        backgroundColor: AppColors.primaryDark,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // شعار التطبيق
            GlassmorphismContainer(
              width: 120,
              height: 120,
              child: const Icon(
                Icons.mosque,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // اسم التطبيق
            Text(
              'أثير - Atheer',
              style: AppTextStyles.arabicTitleLarge.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              'منصة الأذكار الإسلامية',
              style: AppTextStyles.arabicBodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // النص الخاص
            GlassmorphismContainer(
              child: Column(
                children: [
                  Text(
                    '﴾ وَمَا تَوْفِيقِي إِلَّا بِاللَّهِ ﴿',
                    style: AppTextStyles.arabicBodyLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  Text(
                    'تم تصميم هذا العمل بفضل الله ثم بفضل المهندس أحمد محمد الشهاب، وهو صدقة جارية، نسألكم الدعاء لصاحبه ولوالديه.',
                    style: AppTextStyles.arabicBodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // معلومات الاتصال
            GlassmorphismContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'المهندس أحمد محمد الشهاب',
                      style: AppTextStyles.arabicBodyMedium,
                    ),
                    subtitle: Text(
                      'مطور التطبيق',
                      style: AppTextStyles.englishBodySmall,
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'البريد الإلكتروني',
                      style: AppTextStyles.arabicBodyMedium,
                    ),
                    subtitle: Text(
                      AppConstants.developerEmail,
                      style: AppTextStyles.englishBodySmall,
                    ),
                    onTap: _launchEmail,
                  ),
                  
                  ListTile(
                    leading: const Icon(
                      Icons.calendar_today,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'سنة الإصدار',
                      style: AppTextStyles.arabicBodyMedium,
                    ),
                    subtitle: Text(
                      AppConstants.appYear.toString(),
                      style: AppTextStyles.englishBodySmall,
                    ),
                  ),
                  
                  ListTile(
                    leading: const Icon(
                      Icons.code,
                      color: AppColors.primary,
                    ),
                    title: Text(
                      'الإصدار',
                      style: AppTextStyles.arabicBodyMedium,
                    ),
                    subtitle: Text(
                      '${AppConstants.appVersion} (${AppConstants.appYear})',
                      style: AppTextStyles.englishBodySmall,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // حقوق النشر
            Text(
              '© ${AppConstants.appYear} أثير - جميع الحقوق محفوظة',
              style: AppTextStyles.englishBodySmall.copyWith(
                color: AppColors.textLight,
              ),
            ),
            
            const SizedBox(height: 10),
            
            Text(
              'تم التطوير بدقة وعناية لخدمة المسلمين حول العالم',
              style: AppTextStyles.arabicBodySmall.copyWith(
                color: AppColors.textFaded,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
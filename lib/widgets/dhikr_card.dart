import 'package:flutter/material.dart';
import '../models/dhikr_model.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import 'counter_button.dart';

class DhikrCard extends StatelessWidget {
  final Dhikr dhikr;
  final Function() onIncrement;
  final Function() onReset;
  final bool showResetButton;

  const DhikrCard({
    Key? key,
    required this.dhikr,
    required this.onIncrement,
    required this.onReset,
    this.showResetButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين
          children: [
            // حاوية نص الذكر باللون الحليبي - استغلال كامل العرض
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDF5E6), // لون حليبي
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                dhikr.text,
                style: AppTextStyles.arabicBodyMedium.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87, // نص داكن
                ),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
              ),
            ),
            
            const SizedBox(height: 14),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl, // دعم RTL
              children: [
                // العداد وزر الإعادة (على اليمين)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // محاذاة لليمين
                  children: [
                    CounterButton(
                      currentCount: dhikr.currentCount,
                      targetCount: dhikr.targetCount,
                      onIncrement: onIncrement,
                      onReset: onReset,
                      showResetButton: showResetButton,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // مؤشر الإكمال
                    if (dhikr.isFullyCompleted)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accent.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          textDirection: TextDirection.rtl,
                          children: [
                            Text(
                              'مكتمل',
                              style: AppTextStyles.englishBodySmall.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: AppColors.accent,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(width: 16),
                
                // فضل الذكر (على اليسار)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      dhikr.blessing,
                      style: AppTextStyles.arabicBlessing.copyWith(
                        fontSize: 13,
                        color: AppColors.textFaded.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                ),
              ],
            ),
            
            // شريط التقدم
            const SizedBox(height: 14),
            Container(
              height: 4,
              width: double.infinity, // استغلال العرض الكامل
              decoration: BoxDecoration(
                color: AppColors.backgroundDark,
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                widthFactor: dhikr.progress.clamp(0.0, 1.0),
                alignment: Alignment.centerRight, // محاذاة من اليمين
                child: Container(
                  decoration: BoxDecoration(
                    gradient: dhikr.isFullyCompleted 
                        ? AppColors.accentGradient 
                        : AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
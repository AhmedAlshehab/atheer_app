import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class CounterButton extends StatefulWidget {
  final int currentCount;
  final int targetCount;
  final Function() onIncrement;
  final Function() onReset;
  final bool showResetButton;

  const CounterButton({
    Key? key,
    required this.currentCount,
    required this.targetCount,
    required this.onIncrement,
    required this.onReset,
    this.showResetButton = true,
  }) : super(key: key);

  @override
  _CounterButtonState createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  bool _isAnimating = false;

  Future<void> _handleIncrement() async {
    // توقف العداد عند الوصول للعدد المطلوب
    if (_isAnimating || widget.currentCount >= widget.targetCount) return;
    
    setState(() => _isAnimating = true);
    HapticFeedback.lightImpact();
    
    widget.onIncrement();
    
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() => _isAnimating = false);
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = widget.currentCount >= widget.targetCount;
    final double progress = widget.targetCount > 0 
        ? widget.currentCount / widget.targetCount 
        : 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // زر الإعادة
        if (widget.showResetButton && widget.currentCount > 0)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: widget.onReset,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryLight.withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  Icons.refresh,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        
        // دائرة العداد
        GestureDetector(
          onTap: _handleIncrement,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isCompleted
                  ? AppColors.accentGradient
                  : AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: (isCompleted ? AppColors.accent : AppColors.primary)
                      .withOpacity(0.3),
                  blurRadius: _isAnimating ? 20 : 10,
                  spreadRadius: _isAnimating ? 2 : 0,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // تقدم دائري
                if (!isCompleted)
                  SizedBox(
                    width: 56,
                    height: 56,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 2,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                
                // النص
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.currentCount.toString(),
                      style: AppTextStyles.counterText,
                    ),
                    if (isCompleted)
                      const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      ),
                  ],
                ),
                
                // تأثير النبضة
                if (_isAnimating)
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          ),
        ),
        
        // العدد المستهدف
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '/ ${widget.targetCount}',
            style: AppTextStyles.counterTextSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
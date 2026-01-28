import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/dhikr_model.dart';
import '../data/dhikr_data.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../core/utils/share_utils.dart';
import '../widgets/dhikr_card.dart';
import '../widgets/category_header.dart';
import '../services/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final DatabaseService _dbService = DatabaseService();
  final List<Dhikr> _morningDhikr = [];
  final List<Dhikr> _eveningDhikr = [];
  final List<Dhikr> _tasbeehDhikr = [];
  
  bool _isLoading = true;
  int _totalCompleted = 0;
  int _totalTarget = 0;
  double _overallProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    final progressMap = await _dbService.getAllDhikrProgress();
    
    // تحديث بيانات الأذكار بالتقدم المحفوظ
    _updateDhikrWithProgress(DhikrData.morningDhikr, progressMap, _morningDhikr);
    _updateDhikrWithProgress(DhikrData.eveningDhikr, progressMap, _eveningDhikr);
    _updateDhikrWithProgress(DhikrData.tasbeehDhikr, progressMap, _tasbeehDhikr);
    
    // حساب الإحصائيات
    await _calculateStatistics();
    
    setState(() => _isLoading = false);
  }

  void _updateDhikrWithProgress(
    List<Dhikr> source,
    Map<int, Map<String, dynamic>> progressMap,
    List<Dhikr> destination,
  ) {
    destination.clear();
    for (var dhikr in source) {
      final progress = progressMap[dhikr.id];
      if (progress != null) {
        destination.add(dhikr.copyWith(
          currentCount: progress['currentCount'] ?? 0,
          isCompleted: progress['isCompleted'] ?? false,
        ));
      } else {
        destination.add(dhikr.copyWith(currentCount: 0));
      }
    }
  }

  Future<void> _calculateStatistics() async {
    final progressMap = await _dbService.getAllDhikrProgress();
    int totalCompleted = 0;
    progressMap.forEach((key, value) {
      totalCompleted += ((value['currentCount'] ?? 0) as num).toInt();
    });

    final allDhikr = DhikrData.getAllDhikr();
    int totalTarget = 0;
    for (var dhikr in allDhikr) {
      totalTarget += dhikr.targetCount;
    }

    _totalCompleted = totalCompleted;
    _totalTarget = totalTarget;
    _overallProgress =
        (totalTarget > 0) ? (totalCompleted / totalTarget) : 0.0;
  }

  Future<void> _incrementDhikr(Dhikr dhikr, List<Dhikr> list) async {
    final index = list.indexWhere((d) => d.id == dhikr.id);
    if (index != -1) {
      // توقف العداد عند الوصول للرقم المطلوب
      if (list[index].currentCount >= list[index].targetCount) return;
      
      final updatedDhikr = list[index].copyWith(
        currentCount: list[index].currentCount + 1,
        lastUpdated: DateTime.now(),
      );
      
      list[index] = updatedDhikr;
      await _dbService.saveDhikrProgress(updatedDhikr);
      await _calculateStatistics();
      
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _resetDhikr(Dhikr dhikr, List<Dhikr> list) async {
    final index = list.indexWhere((d) => d.id == dhikr.id);
    if (index != -1) {
      final updatedDhikr = list[index].copyWith(
        currentCount: 0,
        isCompleted: false,
        lastUpdated: DateTime.now(),
      );
      
      list[index] = updatedDhikr;
      await _dbService.saveDhikrProgress(updatedDhikr);
      await _calculateStatistics();
      
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> _resetAllProgress() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إعادة تعيين'),
        content: const Text('هل تريد إعادة تعيين جميع العدادات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _dbService.resetAllProgress();
              await _initializeData();
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // AppBar نحيف مثبت
SliverAppBar(
  toolbarHeight: 40, // ارتفاع نحيف 40
  floating: false,
  pinned: true,
  backgroundColor: AppColors.primaryDark,
  title: Row(
    mainAxisSize: MainAxisSize.min,
    textDirection: TextDirection.rtl,
    children: [
      Text(
        'أثير',
        style: AppTextStyles.arabicTitleLarge.copyWith(
          color: Colors.white,
          fontSize: 20,
        ),
        textAlign: TextAlign.right,
      ),
      const SizedBox(width: 12),
      // عداد كلي للأذكار
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.accent.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Text(
          '$_totalCompleted/$_totalTarget',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          textDirection: TextDirection.ltr,
        ),
      ),
    ],
  ),
  centerTitle: true,
  actions: [
    // زر معلومات التطبيق
    IconButton(
      icon: const Icon(Icons.info_outline, color: Colors.white, size: 20),
      onPressed: () {
        Navigator.pushNamed(context, '/about');
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      tooltip: 'معلومات التطبيق',
    ),
    // زر المشاركة
    IconButton(
      icon: const Icon(Icons.share, color: Colors.white, size: 20),
      onPressed: ShareUtils.shareApp,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      tooltip: 'مشاركة التطبيق',
    ),
    // زر إعادة التعيين
    IconButton(
      icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
      onPressed: _resetAllProgress,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      tooltip: 'إعادة تعيين',
    ),
  ],
),
            
            // TabBar مثبت
            SliverPersistentHeader(
              delegate: TabBarDelegate(
                tabController: _tabController,
                onShare: ShareUtils.shareApp,
              ),
              pinned: true,
            ),
          ];
        },
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                controller: _tabController,
                children: [
                  // تبويب أذكار الصباح
                  _buildDhikrList(_morningDhikr),
                  
                  // تبويب أذكار المساء
                  _buildDhikrList(_eveningDhikr),
                  
                  // تبويب التسابيح
                  _buildDhikrList(_tasbeehDhikr),
                ],
              ),
      ),
    );
  }

  Widget _buildDhikrList(List<Dhikr> dhikrList) {
    return CustomScrollView(
      slivers: [
        // رأس القائمة المثبت
        SliverPersistentHeader(
          delegate: CategoryHeader(
            title: _getCategoryTitle(dhikrList),
            itemCount: dhikrList.length,
          ),
          pinned: true,
        ),
        
        // قائمة الأذكار - استغلال عرض الشاشة بشكل أفضل
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final dhikr = dhikrList[index];
                return DhikrCard(
                  dhikr: dhikr,
                  onIncrement: () => _incrementDhikr(dhikr, dhikrList),
                  onReset: () => _resetDhikr(dhikr, dhikrList),
                  showResetButton: dhikr.currentCount > 0,
                );
              },
              childCount: dhikrList.length,
            ),
          ),
        ),
      ],
    );
  }

  String _getCategoryTitle(List<Dhikr> dhikrList) {
    if (dhikrList.isNotEmpty) {
      return dhikrList.first.category;
    }
    return 'الأذكار';
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabController tabController;
  final Function() onShare;

  TabBarDelegate({
    required this.tabController,
    required this.onShare,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم RTL
      child: Container(
        color: AppColors.primaryDark,
        child: Column(
          children: [
            TabBar(
              controller: tabController,
              indicatorColor: AppColors.accent,
              indicatorWeight: 3,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: AppTextStyles.tabTextSelected,
              unselectedLabelStyle: AppTextStyles.tabTextUnselected,
              tabs: const [
                Tab(text: 'أذكار الصباح'),
                Tab(text: 'أذكار المساء'),
                Tab(text: 'تسابيح'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 48;

  @override
  double get minExtent => 48;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
class Dhikr {
  final int id;
  final String text;
  final String blessing;
  final int targetCount;
  int currentCount;
  final String category;
  final String time;
  final bool isCompleted;
  final DateTime? lastUpdated;

  Dhikr({
    required this.id,
    required this.text,
    required this.blessing,
    required this.targetCount,
    required this.category,
    required this.time,
    this.currentCount = 0,
    this.isCompleted = false,
    this.lastUpdated,
  });

  factory Dhikr.fromJson(Map<String, dynamic> json) {
    return Dhikr(
      id: json['id'],
      text: json['text'],
      blessing: json['blessing'],
      targetCount: json['targetCount'],
      currentCount: json['currentCount'] ?? 0,
      category: json['category'],
      time: json['time'],
      isCompleted: json['isCompleted'] ?? false,
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'blessing': blessing,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'category': category,
      'time': time,
      'isCompleted': isCompleted,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  Dhikr copyWith({
    int? currentCount,
    bool? isCompleted,
    DateTime? lastUpdated,
  }) {
    return Dhikr(
      id: id,
      text: text,
      blessing: blessing,
      targetCount: targetCount,
      currentCount: currentCount ?? this.currentCount,
      category: category,
      time: time,
      isCompleted: isCompleted ?? this.isCompleted,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  double get progress => targetCount > 0 ? currentCount / targetCount : 0;
  bool get isFullyCompleted => currentCount >= targetCount;
}
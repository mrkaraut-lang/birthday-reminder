import 'dart:math';

class Birthday {
  final String id;
  final String name;
  final String relation;
  final int month;
  final int day;
  final int? birthYear;

  const Birthday({
    required this.id,
    required this.name,
    required this.relation,
    required this.month,
    required this.day,
    this.birthYear,
  });

  static String generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(9999)}';
  }

  int get daysUntilBirthday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime next = DateTime(now.year, month, day);
    if (next.isBefore(today)) {
      next = DateTime(now.year + 1, month, day);
    }
    return next.difference(today).inDays;
  }

  int? get nextAge {
    if (birthYear == null) return null;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime next = DateTime(now.year, month, day);
    if (next.isBefore(today)) {
      next = DateTime(now.year + 1, month, day);
    }
    return next.year - birthYear!;
  }

  bool get isToday {
    final now = DateTime.now();
    return month == now.month && day == now.day;
  }

  bool get isSoon => daysUntilBirthday > 0 && daysUntilBirthday <= 7;

  String get formattedDate {
    const months = [
      '',
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    final yearStr = birthYear != null ? ' $birthYear г.' : '';
    return '$day ${months[month]}$yearStr';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relation': relation,
    'month': month,
    'day': day,
    'birthYear': birthYear,
  };

  factory Birthday.fromJson(Map<String, dynamic> json) => Birthday(
    id: json['id'] as String,
    name: json['name'] as String,
    relation: json['relation'] as String,
    month: json['month'] as int,
    day: json['day'] as int,
    birthYear: json['birthYear'] as int?,
  );

  Birthday copyWith({
    String? name,
    String? relation,
    int? month,
    int? day,
    int? birthYear,
    bool clearBirthYear = false,
  }) {
    return Birthday(
      id: id,
      name: name ?? this.name,
      relation: relation ?? this.relation,
      month: month ?? this.month,
      day: day ?? this.day,
      birthYear: clearBirthYear ? null : (birthYear ?? this.birthYear),
    );
  }
}

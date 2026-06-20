import 'package:flutter/material.dart';
import '../models/birthday.dart';

class BirthdayCard extends StatelessWidget {
  final Birthday birthday;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const BirthdayCard({
    super.key,
    required this.birthday,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Card(
        elevation: birthday.isToday ? 4 : 1,
        shadowColor: _borderColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border(
                left: BorderSide(color: _borderColor, width: 4),
              ),
              color: birthday.isToday
                  ? const Color(0xFFE91E8C).withOpacity(0.04)
                  : Colors.white,
            ),
            padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
            child: Row(
              children: [
                _Avatar(emoji: _emoji, color: _borderColor),
                const SizedBox(width: 14),
                Expanded(child: _Info(birthday: birthday)),
                const SizedBox(width: 8),
                _Countdown(birthday: birthday),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.grey[400],
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color get _borderColor {
    if (birthday.isToday) return const Color(0xFFE91E8C);
    if (birthday.isSoon) return Colors.orange;
    return const Color(0xFF7986CB);
  }

  String get _emoji {
    const map = {
      'Мама': '👩',
      'Папа': '👨',
      'Бабушка': '👵',
      'Дедушка': '👴',
      'Брат': '👦',
      'Сестра': '👧',
      'Муж': '🧔',
      'Жена': '👰',
      'Сын': '🧒',
      'Дочь': '👧',
      'Тётя': '👩',
      'Дядя': '👨',
      'Другое': '🎂',
    };
    return map[birthday.relation] ?? '🎂';
  }
}

class _Avatar extends StatelessWidget {
  final String emoji;
  final Color color;

  const _Avatar({required this.emoji, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 26,
      backgroundColor: color.withOpacity(0.12),
      child: Text(emoji, style: const TextStyle(fontSize: 22)),
    );
  }
}

class _Info extends StatelessWidget {
  final Birthday birthday;

  const _Info({required this.birthday});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          birthday.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          birthday.relation,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 2),
        Text(
          birthday.formattedDate,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        if (birthday.nextAge != null) ...[
          const SizedBox(height: 3),
          Text(
            birthday.isToday
                ? 'Исполняется ${birthday.nextAge} лет! 🎉'
                : 'Исполнится ${birthday.nextAge} ${_yearsWord(birthday.nextAge!)}',
            style: TextStyle(
              fontSize: 11,
              color: birthday.isToday
                  ? const Color(0xFFE91E8C)
                  : Colors.grey[600],
              fontWeight: birthday.isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ],
    );
  }

  String _yearsWord(int n) {
    if (n % 100 >= 11 && n % 100 <= 19) return 'лет';
    switch (n % 10) {
      case 1:
        return 'год';
      case 2:
      case 3:
      case 4:
        return 'года';
      default:
        return 'лет';
    }
  }
}

class _Countdown extends StatelessWidget {
  final Birthday birthday;

  const _Countdown({required this.birthday});

  @override
  Widget build(BuildContext context) {
    if (birthday.isToday) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE91E8C),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          'Сегодня!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final days = birthday.daysUntilBirthday;
    final color = birthday.isSoon ? Colors.orange : const Color(0xFF7986CB);

    return Container(
      width: 52,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$days',
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _daysWord(days),
            style: TextStyle(color: color, fontSize: 10),
          ),
        ],
      ),
    );
  }

  String _daysWord(int n) {
    if (n % 100 >= 11 && n % 100 <= 19) return 'дней';
    switch (n % 10) {
      case 1:
        return 'день';
      case 2:
      case 3:
      case 4:
        return 'дня';
      default:
        return 'дней';
    }
  }
}

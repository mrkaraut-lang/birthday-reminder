import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/birthday.dart';

class BirthdaysProvider extends ChangeNotifier {
  List<Birthday> _birthdays = [];
  bool _isLoading = true;

  List<Birthday> get birthdays => List.unmodifiable(_birthdays);
  bool get isLoading => _isLoading;

  List<Birthday> get sortedBirthdays {
    final sorted = List<Birthday>.from(_birthdays);
    sorted.sort((a, b) => a.daysUntilBirthday.compareTo(b.daysUntilBirthday));
    return sorted;
  }

  List<Birthday> get todayBirthdays =>
      _birthdays.where((b) => b.isToday).toList();

  BirthdaysProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('birthdays');
    if (data != null) {
      final list = jsonDecode(data) as List<dynamic>;
      _birthdays = list
          .map((e) => Birthday.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'birthdays',
      jsonEncode(_birthdays.map((b) => b.toJson()).toList()),
    );
  }

  Future<void> add(Birthday birthday) async {
    _birthdays.add(birthday);
    notifyListeners();
    await _save();
  }

  Future<void> update(Birthday birthday) async {
    final i = _birthdays.indexWhere((b) => b.id == birthday.id);
    if (i != -1) {
      _birthdays[i] = birthday;
      notifyListeners();
      await _save();
    }
  }

  Future<void> delete(String id) async {
    _birthdays.removeWhere((b) => b.id == id);
    notifyListeners();
    await _save();
  }
}

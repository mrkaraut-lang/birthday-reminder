import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthdays_provider.dart';

class AddEditScreen extends StatefulWidget {
  final Birthday? birthday;

  const AddEditScreen({super.key, this.birthday});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _yearCtrl;

  String _relation = 'Мама';
  DateTime _date = DateTime(2000, 6, 15);

  bool get _isEditing => widget.birthday != null;

  static const List<String> _relations = [
    'Мама', 'Папа', 'Бабушка', 'Дедушка',
    'Брат', 'Сестра', 'Муж', 'Жена',
    'Сын', 'Дочь', 'Тётя', 'Дядя', 'Другое',
  ];

  static const Map<String, String> _emojis = {
    'Мама': '👩', 'Папа': '👨', 'Бабушка': '👵', 'Дедушка': '👴',
    'Брат': '👦', 'Сестра': '👧', 'Муж': '🧔', 'Жена': '👰',
    'Сын': '🧒', 'Дочь': '👧', 'Тётя': '👩', 'Дядя': '👨',
    'Другое': '🎂',
  };

  @override
  void initState() {
    super.initState();
    final b = widget.birthday;
    _nameCtrl = TextEditingController(text: b?.name ?? '');
    _yearCtrl = TextEditingController(text: b?.birthYear?.toString() ?? '');
    if (b != null) {
      _relation = b.relation;
      _date = DateTime(2000, b.month, b.day);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEF8),
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Редактировать' : 'Добавить',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(height: 28),
              _buildCard([
                _nameField(),
                const Divider(height: 1),
                _relationDropdown(),
              ]),
              const SizedBox(height: 16),
              _buildCard([
                _datePicker(),
                const Divider(height: 1),
                _yearField(),
              ]),
              const SizedBox(height: 32),
              _saveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFE91E8C).withOpacity(0.1),
        border: Border.all(
          color: const Color(0xFFE91E8C).withOpacity(0.4),
          width: 2.5,
        ),
      ),
      child: Center(
        child: Text(
          _emojis[_relation] ?? '🎂',
          style: const TextStyle(fontSize: 46),
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _nameField() {
    return TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.words,
      decoration: _inputDecoration('Имя', Icons.person_outline),
      validator: (v) =>
          v == null || v.trim().isEmpty ? 'Введите имя' : null,
    );
  }

  Widget _relationDropdown() {
    return DropdownButtonFormField<String>(
      value: _relation,
      decoration: _inputDecoration('Кем приходится', Icons.people_outline),
      items: _relations
          .map((r) => DropdownMenuItem(
                value: r,
                child: Text('${_emojis[r] ?? ''} $r'),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) setState(() => _relation = v);
      },
    );
  }

  Widget _datePicker() {
    final months = [
      '', 'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];
    final label = '${_date.day} ${months[_date.month]}';

    return InkWell(
      onTap: _pickDate,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            const Icon(Icons.cake_outlined, color: Color(0xFFE91E8C), size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Дата рождения',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _yearField() {
    return TextFormField(
      controller: _yearCtrl,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(
        'Год рождения (необязательно)',
        Icons.calendar_today_outlined,
      ).copyWith(hintText: 'Например: 1990'),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return null;
        final year = int.tryParse(v.trim());
        if (year == null || year < 1900 || year > DateTime.now().year) {
          return 'Введите корректный год';
        }
        return null;
      },
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _save,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFE91E8C),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text(_isEditing ? 'Сохранить изменения' : 'Добавить'),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFFE91E8C), size: 22),
      border: InputBorder.none,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Выберите дату рождения',
      cancelText: 'Отмена',
      confirmText: 'Готово',
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFFE91E8C),
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _date = picked);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<BirthdaysProvider>();
    final yearText = _yearCtrl.text.trim();
    final birthYear = yearText.isNotEmpty ? int.tryParse(yearText) : null;
    final name = _nameCtrl.text.trim();

    if (_isEditing) {
      provider.update(widget.birthday!.copyWith(
        name: name,
        relation: _relation,
        month: _date.month,
        day: _date.day,
        birthYear: birthYear,
        clearBirthYear: birthYear == null,
      ));
    } else {
      provider.add(Birthday(
        id: Birthday.generateId(),
        name: name,
        relation: _relation,
        month: _date.month,
        day: _date.day,
        birthYear: birthYear,
      ));
    }

    Navigator.pop(context);
  }
}

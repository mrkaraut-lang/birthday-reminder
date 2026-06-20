import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/birthday.dart';
import '../providers/birthdays_provider.dart';
import '../widgets/birthday_card.dart';
import 'add_edit_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEF8),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildBody(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _goToAdd(context),
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Добавить'),
        backgroundColor: const Color(0xFFE91E8C),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      backgroundColor: const Color(0xFFE91E8C),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 20, bottom: 14),
        title: const Text(
          'Дни рождения',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFAD1457), Color(0xFFE91E8C), Color(0xFFFF6B9D)],
            ),
          ),
          child: const Align(
            alignment: Alignment(0.7, 0.0),
            child: Text('🎂', style: TextStyle(fontSize: 80)),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<BirthdaysProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final all = provider.sortedBirthdays;

        if (all.isEmpty) {
          return SliverFillRemaining(child: _buildEmpty(context));
        }

        final today = provider.todayBirthdays;
        final items = <Widget>[];

        if (today.isNotEmpty) {
          items.add(_buildTodayBanner(today));
        }

        items.add(_buildSectionHeader('Предстоящие дни рождения (${all.length})'));

        for (final b in all) {
          items.add(BirthdayCard(
            birthday: b,
            onTap: () => _goToEdit(context, b),
            onDelete: () => _confirmDelete(context, b),
          ));
        }

        items.add(const SizedBox(height: 88));

        return SliverList(delegate: SliverChildListDelegate(items));
      },
    );
  }

  Widget _buildTodayBanner(List<Birthday> today) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE91E8C), Color(0xFFFF6B9D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E8C).withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text('🎉', style: TextStyle(fontSize: 42)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Сегодня день рождения!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ...today.map(
                  (b) => Text(
                    '${b.name} · ${b.relation}',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF777777),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎂', style: TextStyle(fontSize: 90)),
            const SizedBox(height: 20),
            const Text(
              'Нет записей',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF444444),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Добавьте дни рождения близких,\nчтобы никогда их не забыть!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF888888), fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _goToAdd(context),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Добавить первый'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E8C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToAdd(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddEditScreen()),
    );
  }

  void _goToEdit(BuildContext context, Birthday birthday) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddEditScreen(birthday: birthday)),
    );
  }

  void _confirmDelete(BuildContext context, Birthday birthday) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Удалить запись?'),
        content: Text(
          'Удалить день рождения "${birthday.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<BirthdaysProvider>().delete(birthday.id);
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
  }
}

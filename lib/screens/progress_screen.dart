import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/languages_data.dart';
import '../widgets/widgets.dart';
import '../main.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppState.I;
    final lang = languageById(app.settings.languageId);
    final learnedCount = app.progress.learnedWordIds.length;
    final totalWords = lang.words.length;

    return ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          FadeSlideIn(child: Text('Твой прогресс', style: Theme.of(context).textTheme.headlineMedium)),
          const SizedBox(height: 18),
          FadeSlideIn(
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department_rounded,
                    color: AppColors.gold,
                    value: '${app.progress.streakDays}',
                    label: 'дней подряд',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.bolt_rounded,
                    color: AppColors.teal,
                    value: '${app.progress.xp}',
                    label: 'опыта',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          FadeSlideIn(
            delayMs: 80,
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.emoji_events_rounded,
                    color: AppColors.violetSoft,
                    value: '${app.progress.level}',
                    label: 'уровень',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.style_rounded,
                    color: AppColors.success,
                    value: '$learnedCount/$totalWords',
                    label: 'слов выучено',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            delayMs: 140,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Изучение ${lang.name}', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: totalWords == 0 ? 0 : learnedCount / totalWords),
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeOutCubic,
                      builder: (context, v, _) => LinearProgressIndicator(
                        value: v,
                        minHeight: 14,
                        backgroundColor: Colors.white.withOpacity(0.08),
                        valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    totalWords == 0
                        ? 'Начни первый урок!'
                        : '${((learnedCount / totalWords) * 100).round()}% словаря освоено',
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          FadeSlideIn(
            delayMs: 200,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('До следующего уровня', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      ProgressRing(
                        value: app.progress.levelProgress,
                        size: 64,
                        center: Text('${(app.progress.levelProgress * 100).round()}%',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Ещё ${app.progress.xpForNextLevel - (app.progress.xp % app.progress.xpForNextLevel)} '
                          'опыта до уровня ${app.progress.level + 1}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  const _StatCard({required this.icon, required this.color, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}


import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/widgets.dart';
import '../main.dart';

class RemindersScreen extends StatefulWidget {
  const RemindersScreen({super.key});

  @override
  State<RemindersScreen> createState() => _RemindersScreenState();
}

class _RemindersScreenState extends State<RemindersScreen> {
  @override
  Widget build(BuildContext context) {
    final app = AppState.I;
    final s = app.settings;

    return ScreenScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.arrow_back_rounded),
              ),
              const SizedBox(width: 14),
              Text('Напоминания', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const SizedBox(height: 8),
          const FadeSlideIn(
            delayMs: 60,
            child: Text('Гномик напомнит тебе позаниматься в удобное время',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ),
          const SizedBox(height: 24),
          FadeSlideIn(
            child: GlassCard(
              child: Row(
                children: [
                  const Icon(Icons.notifications_active_rounded, color: AppColors.teal),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Включить напоминания')),
                  Switch(
                    value: s.remindersOn,
                    activeColor: AppColors.teal,
                    onChanged: (v) {
                      setState(() => s.remindersOn = v);
                      app.saveSettings();
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeSlideIn(
            delayMs: 80,
            child: GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Время напоминания', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [9, 12, 15, 18, 19, 21].map((h) {
                      final selected = s.reminderHour == h;
                      return GestureDetector(
                        onTap: () {
                          setState(() => s.reminderHour = h);
                          app.saveSettings();
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            gradient: selected ? AppColors.primaryButton : null,
                            color: selected ? null : Colors.white.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text('$h:00', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const FadeSlideIn(
            delayMs: 140,
            child: GlassCard(
              borderRadius: 18,
              child: Row(
                children: [
                  Text('💌', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Если пропустишь несколько дней, гномик начнёт скучать всё сильнее — '
                      'но всегда по-доброму.',
                      style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                    ),
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


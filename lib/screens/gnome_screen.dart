import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import '../services/services.dart';
import '../widgets/widgets.dart';
import '../main.dart';

class GnomeScreen extends StatefulWidget {
  const GnomeScreen({super.key});

  @override
  State<GnomeScreen> createState() => _GnomeScreenState();
}

class _GnomeScreenState extends State<GnomeScreen> {
  late String _phrase;

  @override
  void initState() {
    super.initState();
    _phrase = _currentPhrase();
  }

  String _currentPhrase() {
    final ps = ProgressService(AppState.I.progress);
    final mood = GnomeService.moodFor(ps.daysSinceLastLesson());
    return GnomeService.randomPhrase(mood);
  }

  GnomeMood get _mood {
    final ps = ProgressService(AppState.I.progress);
    return GnomeService.moodFor(ps.daysSinceLastLesson());
  }

  void _poke() {
    SoundService.click();
    setState(() => _phrase = _currentPhrase());
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back_rounded),
                ),
                const SizedBox(width: 14),
                Text('Твой гномик', style: Theme.of(context).textTheme.headlineMedium),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: FadeSlideIn(
                child: GnomeWidget(mood: _mood, phrase: _phrase, size: 200, onTap: _poke),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
            child: FadeSlideIn(
              child: PrimaryButton(
                label: 'Поболтать с гномиком',
                icon: Icons.chat_bubble_rounded,
                onPressed: _poke,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

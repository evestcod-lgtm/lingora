import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models.dart';
import '../services/services.dart';

/// Фоновый градиент с мягкими светящимися пятнами — используется на каждом экране.
class GradientBackground extends StatelessWidget {
  final Widget child;
  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.background),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -60,
            child: _glowBlob(AppColors.violetSoft.withOpacity(0.35), 220),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _glowBlob(AppColors.teal.withOpacity(0.25), 260),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }

  Widget _glowBlob(Color color, double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, Colors.transparent]),
        ),
      );
}

/// Стеклянная карточка с мягкой тенью и лёгким блюром.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  final double borderRadius;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.borderRadius = 24,
  });

  @override
  Widget build(BuildContext context) {
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.white.withOpacity(0.14)),
            boxShadow: [
              BoxShadow(
                color: AppColors.violetPrimary.withOpacity(0.18),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
    if (onTap == null) return card;
    return _TapScale(onTap: onTap!, child: card);
  }
}

/// Обёртка, дающая лёгкий "пружинный" отклик на нажатие любому виджету.
class _TapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const _TapScale({required this.child, required this.onTap});

  @override
  State<_TapScale> createState() => _TapScaleState();
}

class _TapScaleState extends State<_TapScale> with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        SoundService.click();
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Основная округлая кнопка с градиентом и свечением.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Gradient? gradient;
  final double height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.gradient,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return _TapScale(
      onTap: onPressed,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 28),
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.primaryButton,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: [
            BoxShadow(
              color: AppColors.violetPrimary.withOpacity(0.45),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Кольцевой индикатор прогресса (для XP / уровня).
class ProgressRing extends StatelessWidget {
  final double value; // 0..1
  final double size;
  final Widget? center;

  const ProgressRing({super.key, required this.value, this.size = 72, this.center});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0, 1)),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, v, _) => CircularProgressIndicator(
              value: v,
              strokeWidth: 7,
              backgroundColor: Colors.white.withOpacity(0.12),
              valueColor: const AlwaysStoppedAnimation(AppColors.teal),
            ),
          ),
          if (center != null) center!,
        ],
      ),
    );
  }
}

/// Гномик-помощник: живой персонаж с настроением, лёгкой анимацией
/// покачивания и всплывающей фразой.
class GnomeWidget extends StatefulWidget {
  final GnomeMood mood;
  final String phrase;
  final double size;
  final VoidCallback? onTap;

  const GnomeWidget({
    super.key,
    required this.mood,
    required this.phrase,
    this.size = 120,
    this.onTap,
  });

  @override
  State<GnomeWidget> createState() => _GnomeWidgetState();
}

class _GnomeWidgetState extends State<GnomeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _glow => switch (widget.mood) {
        GnomeMood.joyful => AppColors.teal,
        GnomeMood.content => AppColors.tealSoft,
        GnomeMood.bored => AppColors.violetSoft,
        GnomeMood.grumpy => AppColors.gold,
        GnomeMood.pleading => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final dy = (widget.mood == GnomeMood.pleading ? 6 : 4) *
                  (_controller.value - 0.5);
              final rotate = (widget.mood == GnomeMood.grumpy ? 0.04 : 0.02) *
                  (_controller.value - 0.5);
              return Transform.translate(
                offset: Offset(0, dy),
                child: Transform.rotate(angle: rotate, child: child),
              );
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [_glow.withOpacity(0.55), Colors.transparent],
                ),
              ),
              child: Container(
                width: widget.size * 0.72,
                height: widget.size * 0.72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.violetDeep,
                  border: Border.all(color: _glow, width: 3),
                ),
                child: Center(
                  child: Text(
                    widget.mood.emoji,
                    style: TextStyle(fontSize: widget.size * 0.34),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: GlassCard(
              key: ValueKey(widget.phrase),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              borderRadius: 18,
              child: Text(
                widget.phrase,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Анимация звёздной награды — появляется поверх экрана при успехе/левелапе.
class RewardBurst extends StatefulWidget {
  final VoidCallback onDone;
  final String label;
  const RewardBurst({super.key, required this.onDone, this.label = '+10 XP'});

  @override
  State<RewardBurst> createState() => _RewardBurstState();
}

class _RewardBurstState extends State<RewardBurst> with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..forward().whenComplete(widget.onDone);
    SoundService.reward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) {
        final scale = Curves.elasticOut.transform(_c.value.clamp(0, 1));
        final opacity = 1 - Curves.easeIn.transform((_c.value - 0.6).clamp(0, 1) / 0.4);
        return Opacity(
          opacity: opacity.clamp(0, 1),
          child: Transform.scale(
            scale: 0.6 + scale * 0.6,
            child: child,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          gradient: AppColors.goldButton,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.gold.withOpacity(0.6), blurRadius: 30),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('⭐', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Text(widget.label,
                style: const TextStyle(
                    color: Color(0xFF3A2600), fontWeight: FontWeight.w800, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

/// Плавное появление экрана снизу с затуханием — используем во всех экранах.
class FadeSlideIn extends StatelessWidget {
  final Widget child;
  final int delayMs;
  const FadeSlideIn({super.key, required this.child, this.delayMs = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, v, child) {
        return Opacity(
          opacity: v,
          child: Transform.translate(offset: Offset(0, (1 - v) * 24), child: child),
        );
      },
      child: child,
    );
  }
}

/// Обёртка над скролл-контентом экрана с общими отступами.
class ScreenScaffold extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const ScreenScaffold({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.fromLTRB(20, 16, 20, 24),
  });

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SingleChildScrollView(padding: padding, child: child),
    );
  }
}

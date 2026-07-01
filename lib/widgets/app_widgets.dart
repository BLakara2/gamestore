import 'dart:math';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static const primary = Color(0xFFE8828A);
  static const primaryDark = Color(0xFFD1646E);
  static const primaryLight = Color(0xFFF2B6C1);
  static const primaryBg = Color(0xFFFEF0F2);
  static const secondary = Color(0xFFFFB5A7);
  static const secondaryLight = Color(0xFFFFE0D6);
  static const tertiary = Color(0xFFC9A5D4);
  static const surface = Color(0xFFFDF6F0);
  static const surfaceContainer = Color(0xFFF5ECE6);
  static const onSurface = Color(0xFF2D2320);
  static const onSurfaceVariant = Color(0xFF8C7E7A);
  static const warmWhite = Color(0xFFFFFBF8);
}

class AppTheme {
  AppTheme._();
  static ThemeData build() {
    final scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primaryDark,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.tertiary,
      onTertiary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      surfaceContainerHighest: AppColors.surfaceContainer,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.warmWhite,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          shadowColor: AppColors.primary.withAlpha(76),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primaryLight.withAlpha(76)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColors.primaryLight.withAlpha(50)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        labelStyle: TextStyle(color: AppColors.onSurfaceVariant),
        prefixIconColor: AppColors.onSurfaceVariant,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: AppColors.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        iconTheme: const IconThemeData(color: AppColors.onSurface),
      ),
    );
  }
}

Route fadeSlideRoute(Widget page) => PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, a, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.08, 0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: a, curve: Curves.easeOutCubic)),
        child: FadeTransition(opacity: a, child: child),
      ),
      transitionDuration: const Duration(milliseconds: 350),
    );

class GradientBg extends StatelessWidget {
  final Widget child;
  const GradientBg({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warmWhite,
            AppColors.primaryBg,
            AppColors.secondaryLight.withAlpha(127),
          ],
        ),
      ),
      child: child,
    );
  }
}

class HeartPulse extends StatefulWidget {
  final Widget child;
  final double minScale;
  final Duration period;
  const HeartPulse({
    super.key,
    required this.child,
    this.minScale = 0.9,
    this.period = const Duration(milliseconds: 1300),
  });

  @override
  State<HeartPulse> createState() => _HeartPulseState();
}

class _HeartPulseState extends State<HeartPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.period)
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: widget.minScale, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Transform.scale(scale: _anim.value, child: child),
      child: widget.child,
    );
  }
}

class FloatingHearts extends StatefulWidget {
  const FloatingHearts({super.key});

  @override
  State<FloatingHearts> createState() => _FloatingHeartsState();
}

class _FloatingHeartsState extends State<FloatingHearts>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late final List<_HeartData> _data;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))
      ..repeat();
    _data = List.generate(5, (_) => _HeartData(Random()));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => Stack(
          children: _data.map((d) {
            final progress = (_ctrl.value + d.phase) % 1.0;
            final y = size.height * (1 + 0.2 - progress * 1.4);
            final x = d.x * size.width + sin(progress * 2 * pi) * 15;
            final opacity = progress < 0.1
                ? progress / 0.1
                : progress > 0.8
                    ? (1 - progress) / 0.2
                    : 1.0;
            return Positioned(
              left: x.clamp(0, size.width - d.size),
              top: y,
              child: Opacity(
                opacity: opacity * 0.3,
                child: Icon(Icons.favorite, size: d.size, color: AppColors.primaryLight),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _HeartData {
  final double x, phase, size;
  _HeartData(Random rng)
      : x = rng.nextDouble(),
        phase = rng.nextDouble(),
        size = 14 + rng.nextDouble() * 18;
}

class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  State<Confetti> createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late final List<_ConfettiPiece> _pieces;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 5))
      ..repeat();
    _pieces = List.generate(15, (_) => _ConfettiPiece(Random()));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, _) => Stack(
          children: _pieces.map((p) {
            final progress = (_ctrl.value + p.phase) % 1.0;
            final y = size.height * (1 + 0.1 - progress * 1.3);
            final x = p.x * size.width + sin(progress * 3 * pi) * 25;
            final opacity = progress < 0.1
                ? progress / 0.1
                : progress > 0.85
                    ? (1 - progress) / 0.15
                    : 1.0;
            final scale = progress < 0.3 ? progress / 0.3 : 1.0;
            return Positioned(
              left: x.clamp(0, size.width - 12),
              top: y,
              child: Opacity(
                opacity: opacity * 0.7,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: p.size,
                    height: p.size,
                    decoration: BoxDecoration(
                      color: p.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ConfettiPiece {
  final double x, phase, size;
  final Color color;
  _ConfettiPiece(Random rng)
      : x = rng.nextDouble(),
        phase = rng.nextDouble(),
        size = 5 + rng.nextDouble() * 7,
        color = [AppColors.primary, AppColors.primaryLight, AppColors.secondary, AppColors.tertiary, Colors.amber][rng.nextInt(5)];
}

class StepDots extends StatelessWidget {
  final int current;
  final int total;
  const StepDots({super.key, required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(total, (i) {
          final active = i < current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: active ? 24 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? AppColors.primary : AppColors.primaryLight.withAlpha(80),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

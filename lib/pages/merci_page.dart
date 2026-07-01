import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';
import 'profile_page.dart';

class MerciPage extends StatelessWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  final String activite;
  final String repas;
  final String? mapsLink;
  const MerciPage({
    super.key,
    required this.name,
    required this.birthDate,
    required this.lieu,
    required this.activite,
    required this.repas,
    this.mapsLink,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          const Confetti(),
          GradientBg(
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _StaggeredText(
                        delay: 0,
                        child: HeartPulse(
                          child: Icon(Icons.favorite,
                              size: 96, color: AppColors.primary),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _StaggeredText(
                        delay: 200,
                        child: Text('Merci $name !',
                            textAlign: TextAlign.center,
                            style: t.textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      _StaggeredText(
                        delay: 400,
                        child: Text(
                            'J\'ai hâte de passer ce moment avec toi',
                            textAlign: TextAlign.center,
                            style: t.textTheme.titleLarge),
                      ),
                      const SizedBox(height: 24),
                      _StaggeredText(
                        delay: 600,
                        child: Text(
                            'Je te prépare le programme parfait…',
                            textAlign: TextAlign.center,
                            style: t.textTheme.bodyLarge?.copyWith(
                                color: t.colorScheme.onSurfaceVariant)),
                      ),
                      const SizedBox(height: 48),
                      _StaggeredText(
                        delay: 800,
                        child: SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pushAndRemoveUntil(
                                context,
                                fadeSlideRoute(const ProfilePage()),
                                (_) => false),
                            icon: const Icon(Icons.home),
                            label: const Text('Accueil'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredText extends StatefulWidget {
  final int delay;
  final Widget child;
  const _StaggeredText({required this.delay, required this.child});

  @override
  State<_StaggeredText> createState() => _StaggeredTextState();
}

class _StaggeredTextState extends State<_StaggeredText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late CurvedAnimation _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _anim.dispose();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => Opacity(
        opacity: _anim.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - _anim.value)),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

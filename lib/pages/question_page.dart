import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';
import 'selection_page.dart';
import 'maps_page.dart';

class QuestionPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  const QuestionPage({super.key, required this.name, required this.birthDate});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage>
    with SingleTickerProviderStateMixin {
  double _noX = 0, _noY = 0;
  final double _btnW = 160, _btnH = 54;
  bool _init = false;

  late AnimationController _glowCtrl;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _glowCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    super.dispose();
  }

  void _goToLieu() {
    Navigator.push(
      context,
      fadeSlideRoute(SelectionPage(
        stepLabel: 'Étape 1 sur 4',
        icon: Icons.location_on_outlined,
        title: 'Quel lieu te ferait rêver ?',
        subtitle: 'Choisis un seul endroit où tu aimerais qu\'on aille',
        items: lieuItems,
        onNext: _goToActivite,
      )),
    );
  }

  void _goToActivite(String lieu) {
    Navigator.push(
      context,
      fadeSlideRoute(SelectionPage(
        stepLabel: 'Étape 2 sur 4',
        icon: Icons.celebration_outlined,
        title: 'Quelle activité te tenterait ?',
        subtitle: 'Choisis une activité qu\'on pourrait faire ensemble',
        items: activiteItems,
        onNext: (activite) => _goToRepas(lieu, activite),
      )),
    );
  }

  void _goToRepas(String lieu, String activite) {
    Navigator.push(
      context,
      fadeSlideRoute(SelectionPage(
        stepLabel: 'Étape 3 sur 4',
        icon: Icons.restaurant_outlined,
        title: 'Qu\'aimerais-tu manger ?',
        subtitle: 'Choisis ce qui te ferait plaisir à déguster',
        items: repasItems,
        onNext: (repas) => _goToMaps(lieu, activite, repas),
      )),
    );
  }

  void _goToMaps(String lieu, String activite, String repas) {
    Navigator.push(
      context,
      fadeSlideRoute(MapsPage(
        name: widget.name,
        birthDate: widget.birthDate,
        lieu: lieu,
        activite: activite,
        repas: repas,
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final t = Theme.of(context);
    if (!_init) {
      _noX = (s.width - _btnW) / 2;
      _noY = s.height / 2 + 140;
      _init = true;
    }

    return Scaffold(
      body: Stack(
        children: [
          const FloatingHearts(),
          GradientBg(
            child: Listener(
              onPointerMove: (e) => _move(e.position.dx, e.position.dy, s),
              onPointerDown: (e) => _move(e.position.dx, e.position.dy, s),
              behavior: HitTestBehavior.translucent,
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          HeartPulse(
                            child: Icon(Icons.favorite,
                                size: 80, color: t.colorScheme.primary),
                          ),
                          const SizedBox(height: 24),
                          Text(widget.name,
                              textAlign: TextAlign.center,
                              style: t.textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Veux-tu sortir avec moi ?',
                              textAlign: TextAlign.center,
                              style: t.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          Text('Fais-moi le plus grand des bonheurs...',
                              textAlign: TextAlign.center,
                              style: t.textTheme.bodyLarge
                                  ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                          const SizedBox(height: 48),
                          AnimatedBuilder(
                            animation: _glowAnim,
                            builder: (_, child) => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary
                                        .withAlpha((50 + 60 * _glowAnim.value).round()),
                                    blurRadius: 6 + 14 * _glowAnim.value,
                                    spreadRadius: -2,
                                  ),
                                ],
                              ),
                              child: child,
                            ),
                            child: SizedBox(
                              width: _btnW,
                              height: _btnH,
                              child: ElevatedButton.icon(
                                onPressed: _goToLieu,
                                icon: const Icon(Icons.favorite),
                                label: const Text('OUI'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            left: _noX,
                            top: _noY,
                            child: SizedBox(
                              width: _btnW,
                              height: _btnH,
                              child: ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.close),
                                label: const Text('NON'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.grey.shade500,
                                  disabledBackgroundColor: Colors.grey.shade200,
                                  disabledForegroundColor: Colors.grey.shade500,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  void _move(double px, double py, Size s) {
    final dist =
        ((px - _noX - _btnW / 2).abs() + (py - _noY - _btnH / 2).abs());
    if (dist < 250) {
      setState(() {
        double nx, ny;
        int att = 0;
        do {
          final seed = DateTime.now().microsecondsSinceEpoch;
          nx = (s.width - _btnW) *
              (0.05 + 0.9 * ((seed + att) % 1000) / 1000);
          ny = (s.height - _btnH) *
              (0.05 + 0.9 * ((seed + 500 + att) % 1000) / 1000);
          att++;
        } while (att < 10 && ((nx - px).abs() + (ny - py).abs()) < 300);
        _noX = nx.clamp(0, s.width - _btnW);
        _noY = ny.clamp(0, s.height - _btnH);
      });
    }
  }
}

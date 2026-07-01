import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';

class SelectionItem {
  final String name;
  final IconData icon;
  final Color color;
  const SelectionItem(this.name, this.icon, this.color);
}

const lieuItems = [
  SelectionItem('Restaurant romantique', Icons.restaurant, Color(0xFFE8828A)),
  SelectionItem('Parc / Jardin', Icons.park, Color(0xFF6B9E6B)),
  SelectionItem('Plage', Icons.beach_access, Color(0xFF6BA3C7)),
  SelectionItem('Cinéma', Icons.movie, Color(0xFF8B6BBF)),
  SelectionItem('Bowling', Icons.sports_kabaddi, Color(0xFFE8A06B)),
  SelectionItem('Musée', Icons.museum, Color(0xFFA67C6B)),
  SelectionItem('Aquarium', Icons.water, Color(0xFF5FAFAF)),
  SelectionItem('Pique-nique', Icons.outdoor_grill, Color(0xFF8FBF6B)),
];

const activiteItems = [
  SelectionItem('Se promener main dans la main', Icons.directions_walk, Color(0xFFE8828A)),
  SelectionItem('Regarder un film', Icons.tv, Color(0xFF6B7BBF)),
  SelectionItem('Mini-golf', Icons.golf_course, Color(0xFF6B9E6B)),
  SelectionItem('Faire du shopping', Icons.shopping_bag, Color(0xFFB57BBF)),
  SelectionItem('Jeux de société', Icons.gamepad, Color(0xFFD4A56B)),
  SelectionItem('Karaoké', Icons.mic, Color(0xFFE87A5A)),
  SelectionItem('Patinoire', Icons.snowboarding, Color(0xFF5FAFAF)),
  SelectionItem('Escape game', Icons.lock, Color(0xFFA67C6B)),
];

const repasItems = [
  SelectionItem('Pizza', Icons.local_pizza, Color(0xFFE8A06B)),
  SelectionItem('Sushis', Icons.set_meal, Color(0xFFE87A7A)),
  SelectionItem('Pâtes', Icons.dining, Color(0xFFD4B06B)),
  SelectionItem('Burger', Icons.lunch_dining, Color(0xFFA67C6B)),
  SelectionItem('Glace', Icons.icecream, Color(0xFFE8828A)),
  SelectionItem('Crêpes', Icons.cake, Color(0xFFE8D06B)),
  SelectionItem('Mexicain', Icons.takeout_dining, Color(0xFF6B9E6B)),
  SelectionItem('Barbecue', Icons.fireplace, Color(0xFFE87A5A)),
];

class SelectionPage extends StatefulWidget {
  final String stepLabel;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<SelectionItem> items;
  final void Function(String selected) onNext;

  const SelectionPage({
    super.key,
    required this.stepLabel,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.onNext,
  });

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage>
    with SingleTickerProviderStateMixin {
  String? _selected;
  late AnimationController _staggerCtrl;
  late List<CurvedAnimation> _itemAnims;

  int get _stepNumber {
    final parts = widget.stepLabel.split(' ');
    if (parts.length >= 2) {
      final n = int.tryParse(parts[1]);
      if (n != null) return n;
    }
    return 1;
  }

  @override
  void initState() {
    super.initState();
    _staggerCtrl = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.items.length * 50),
    );
    _itemAnims = List.generate(widget.items.length, (i) {
      final start = i * 0.06;
      return CurvedAnimation(
        parent: _staggerCtrl,
        curve: Interval(start, (start + 0.25).clamp(0, 1),
            curve: Curves.easeOutCubic),
      );
    });
    _staggerCtrl.forward();
  }

  @override
  void dispose() {
    _staggerCtrl.dispose();
    for (final a in _itemAnims) {
      a.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.stepLabel)),
      body: GradientBg(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
            child: Column(
              children: [
                StepDots(current: _stepNumber, total: 4),
                const SizedBox(height: 4),
                Center(
                  child: Column(
                    children: [
                      Icon(widget.icon,
                          size: 40, color: t.colorScheme.primary),
                      const SizedBox(height: 12),
                      Text(widget.title,
                          textAlign: TextAlign.center,
                          style: t.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(widget.subtitle,
                          textAlign: TextAlign.center,
                          style: t.textTheme.bodyMedium
                              ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: widget.items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (_, i) {
                      final item = widget.items[i];
                      final sel = _selected == item.name;
                      final anim = _itemAnims[i];
                      return AnimatedBuilder(
                        animation: anim,
                        builder: (_, child) => Opacity(
                          opacity: anim.value,
                          child: Transform.translate(
                            offset: Offset(0, 16 * (1 - anim.value)),
                            child: child,
                          ),
                        ),
                        child: _SelectionCard(
                          item: item,
                          selected: sel,
                          onTap: () => setState(() => _selected = item.name),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed:
                        _selected == null ? null : () => widget.onNext(_selected!),
                    icon: const Icon(Icons.arrow_forward, size: 20),
                    label: const Text('Suivant'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final SelectionItem item;
  final bool selected;
  final VoidCallback onTap;

  const _SelectionCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = item.color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: selected ? color.withAlpha(18) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? color : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: selected
                  ? color.withAlpha(25)
                  : Colors.black.withAlpha(8),
              blurRadius: selected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(item.icon,
                  color: selected ? color : AppColors.onSurfaceVariant,
                  size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                    color: selected ? color : AppColors.onSurface,
                  ),
                ),
              ),
              AnimatedScale(
                scale: selected ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutBack,
                child: Icon(Icons.check_circle, color: color, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const DateApp());
}

class DateApp extends StatelessWidget {
  const DateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sortir avec moi ?',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  DateTime? _birthDate;

  bool get _valid =>
      _nameController.text.trim().isNotEmpty && _birthDate != null;

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2002),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (date != null) setState(() => _birthDate = date);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.tertiary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 64, color: theme.colorScheme.primary),
                const SizedBox(height: 20),
                Text(
                  'On fait connaissance ?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dis-moi un peu qui tu es ✨',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nom Facebook',
                    hintText: 'Ton nom Facebook',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surface,
                  ),
                  textCapitalization: TextCapitalization.words,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(12),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Date de naissance',
                      prefixIcon: const Icon(Icons.cake),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                    ),
                    child: Text(
                      _birthDate != null
                          ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                          : 'Sélectionne ta date de naissance',
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _valid
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuestionPage(
                                  name: _nameController.text.trim(),
                                  birthDate: _birthDate!,
                                ),
                              ),
                            );
                          }
                        : null,
                    icon: const Icon(Icons.favorite),
                    label: const Text(
                      'Continuer',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
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

class QuestionPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  const QuestionPage({super.key, required this.name, required this.birthDate});

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  double _noX = 0;
  double _noY = 0;
  final double _buttonWidth = 160;
  final double _buttonHeight = 52;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    if (!_initialized) {
      _noX = (size.width - _buttonWidth) / 2;
      _noY = size.height / 2 + 120;
      _initialized = true;
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              theme.colorScheme.tertiary.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite, size: 80, color: theme.colorScheme.primary),
                    const SizedBox(height: 24),
                    Text(
                      '${widget.name},',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Veux-tu sortir avec moi ?',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Fais-moi le plus grand des bonheurs... ❤️',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 48),
                    SizedBox(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DateOptionsPage(
                                name: widget.name,
                                birthDate: widget.birthDate,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.favorite),
                        label: const Text(
                          'OUI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(width: _buttonWidth, height: _buttonHeight),
                  ],
                ),
              ),
            ),
            Listener(
              onPointerMove: (event) {
                _moveNoAway(event.position.dx, event.position.dy, size);
              },
              onPointerDown: (event) {
                _moveNoAway(event.position.dx, event.position.dy, size);
              },
              child: Stack(
                children: [
                  Positioned(
                    left: _noX,
                    top: _noY,
                    child: SizedBox(
                      width: _buttonWidth,
                      height: _buttonHeight,
                      child: ElevatedButton.icon(
                        onPressed: null,
                        icon: const Icon(Icons.close),
                        label: const Text(
                          'NON',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.grey.shade600,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveNoAway(double px, double py, Size size) {
    final cx = _noX + _buttonWidth / 2;
    final cy = _noY + _buttonHeight / 2;
    final dist = (px - cx).abs() + (py - cy).abs();
    if (dist < 150) {
      setState(() {
        double newX, newY;
        int attempts = 0;
        do {
          final seed = DateTime.now().microsecondsSinceEpoch;
          newX = (size.width - _buttonWidth) *
              (0.05 + 0.9 * ((seed + attempts) % 1000) / 1000);
          newY = (size.height - _buttonHeight) *
              (0.05 + 0.9 * ((seed + 500 + attempts) % 1000) / 1000);
          attempts++;
        } while (attempts < 10 &&
            ((newX - px).abs() + (newY - py).abs()) < 200);
        _noX = newX.clamp(0, size.width - _buttonWidth);
        _noY = newY.clamp(0, size.height - _buttonHeight);
      });
    }
  }
}

class DateOptionsPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  const DateOptionsPage({super.key, required this.name, required this.birthDate});

  @override
  State<DateOptionsPage> createState() => _DateOptionsPageState();
}

class _DateOptionsPageState extends State<DateOptionsPage> {
  final _mapsController = TextEditingController();

  final Map<String, Set<String>> _selected = {
    'lieux': <String>{},
    'activites': <String>{},
    'repas': <String>{},
  };

  final Map<String, List<Map<String, dynamic>>> _categories = {
    'lieux': [
      {'name': 'Restaurant romantique', 'icon': Icons.restaurant, 'color': Colors.red},
      {'name': 'Parc / Jardin', 'icon': Icons.park, 'color': Colors.green},
      {'name': 'Plage', 'icon': Icons.beach_access, 'color': Colors.blue},
      {'name': 'Cinéma', 'icon': Icons.movie, 'color': Colors.deepPurple},
      {'name': 'Bowling', 'icon': Icons.sports_kabaddi, 'color': Colors.orange},
      {'name': 'Musée', 'icon': Icons.museum, 'color': Colors.brown},
      {'name': 'Aquarium', 'icon': Icons.water, 'color': Colors.teal},
      {'name': 'Pique-nique', 'icon': Icons.outdoor_grill, 'color': Colors.lime},
    ],
    'activites': [
      {'name': 'Se promener main dans la main', 'icon': Icons.directions_walk, 'color': Colors.pink},
      {'name': 'Regarder un film', 'icon': Icons.tv, 'color': Colors.indigo},
      {'name': 'Mini-golf', 'icon': Icons.golf_course, 'color': Colors.green},
      {'name': 'Faire du shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple},
      {'name': 'Jeux de société', 'icon': Icons.gamepad, 'color': Colors.amber},
      {'name': 'Karaoké', 'icon': Icons.mic, 'color': Colors.deepOrange},
      {'name': 'Patinoire', 'icon': Icons.snowboarding, 'color': Colors.cyan},
      {'name': 'Escape game', 'icon': Icons.lock, 'color': Colors.brown},
    ],
    'repas': [
      {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Colors.orange},
      {'name': 'Sushis', 'icon': Icons.set_meal, 'color': Colors.red},
      {'name': 'Pâtes', 'icon': Icons.dining, 'color': Colors.amber},
      {'name': 'Burger', 'icon': Icons.lunch_dining, 'color': Colors.brown},
      {'name': 'Glace', 'icon': Icons.icecream, 'color': Colors.pink},
      {'name': 'Crêpes', 'icon': Icons.cake, 'color': Colors.yellow},
      {'name': 'Mexicain', 'icon': Icons.takeout_dining, 'color': Colors.green},
      {'name': 'Barbecue', 'icon': Icons.fireplace, 'color': Colors.deepOrange},
    ],
  };

  void _toggle(String category, String name) {
    setState(() {
      if (_selected[category]!.contains(name)) {
        _selected[category]!.remove(name);
      } else {
        _selected[category]!.add(name);
      }
    });
  }

  bool get _hasSelection => _selected.values.any((s) => s.isNotEmpty);

  Future<void> _sendEmail() async {
    final selectedLieux = _selected['lieux']!.join(', ');
    final selectedActivites = _selected['activites']!.join(', ');
    final selectedRepas = _selected['repas']!.join(', ');
    final mapsLink = _mapsController.text.trim();
    final birthStr =
        '${widget.birthDate.day}/${widget.birthDate.month}/${widget.birthDate.year}';

    final body = StringBuffer()
      ..writeln('Salut Bryan,')
      ..writeln()
      ..writeln('${widget.name} a accepté de sortir avec toi ! ❤️')
      ..writeln()
      ..writeln('Née le : $birthStr')
      ..writeln()
      ..writeln('Ses choix préférés (à toi de faire le programme final) :');

    if (selectedLieux.isNotEmpty) {
      body.writeln();
      body.writeln('Lieux : $selectedLieux');
    }
    if (selectedActivites.isNotEmpty) {
      body.writeln('Activités : $selectedActivites');
    }
    if (selectedRepas.isNotEmpty) {
      body.writeln('À manger : $selectedRepas');
    }

    if (mapsLink.isNotEmpty) {
      body.writeln();
      body.writeln('Lieu Google Maps souhaité :');
      body.writeln(mapsLink);
    }

    body.writeln();
    body.writeln('Fonce champion ! 🎉');

    final uri = Uri(
      scheme: 'mailto',
      path: 'lakarabryan@gmail.com',
      queryParameters: {
        'subject': '${widget.name} a accepté de sortir avec toi ! 🎉',
        'body': body.toString(),
      },
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  void dispose() {
    _mapsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notre date parfait ❤️'),
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Choisis tes préférés ✨',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coche tout ce qui te fait envie,',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'je me chargerai de faire la sélection finale 😉',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ..._categories.entries.map((entry) {
            return _buildCategory(context, entry.key, entry.value);
          }),
          const SizedBox(height: 16),
          TextField(
            controller: _mapsController,
            decoration: InputDecoration(
              labelText: 'Lieu Google Maps souhaité',
              hintText: 'Colle un lien Google Maps ici',
              prefixIcon: const Icon(Icons.map),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: theme.colorScheme.surface,
            ),
            maxLines: 2,
            keyboardType: TextInputType.url,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 24),
          if (_hasSelection || _mapsController.text.trim().isNotEmpty)
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(Icons.celebration, size: 48, color: theme.colorScheme.primary),
                    const SizedBox(height: 12),
                    Text(
                      'Résumé de nos préférences :',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final entry in _selected.entries)
                      if (entry.value.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  _getCategoryLabel(entry.key),
                                  style: const TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(entry.value.join(', ')),
                              ),
                            ],
                          ),
                        ),
                    if (_mapsController.text.trim().isNotEmpty) ...[
                      const Divider(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 80,
                            child: Text('Lieu maps', style: TextStyle(fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _mapsController.text.trim(),
                              style: TextStyle(color: theme.colorScheme.primary),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _showConfirmDialog(context);
                        },
                        icon: const Icon(Icons.email),
                        label: const Text(
                          'Confirmer et envoyer ❤️',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _getCategoryLabel(String key) {
    switch (key) {
      case 'lieux':
        return 'Lieux';
      case 'activites':
        return 'Activités';
      case 'repas':
        return 'À manger';
      default:
        return key;
    }
  }

  Widget _buildCategory(BuildContext context, String category, List<Map<String, dynamic>> items) {
    final label = _getCategoryLabel(category);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8, top: 12),
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items.map((item) {
          final name = item['name'] as String;
          final icon = item['icon'] as IconData;
          final color = item['color'] as Color;
          final isSelected = _selected[category]!.contains(name);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isSelected
                  ? BorderSide(color: color, width: 2)
                  : BorderSide.none,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _toggle(category, name),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Icon(icon, color: isSelected ? color : Colors.grey, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? color : null,
                        ),
                      ),
                    ),
                    if (isSelected) Icon(Icons.check_circle, color: color),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  void _showConfirmDialog(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Icon(Icons.favorite, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'C\'est officiel ! 🎉',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Je vais envoyer un email à Bryan\navec tous tes choix ❤️',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Text(
              'Il te prépare le programme parfait !',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _sendEmail();
                },
                icon: const Icon(Icons.email),
                label: const Text('Envoyer l\'email ❤️'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

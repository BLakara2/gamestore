import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

const _emailUser = String.fromEnvironment('EMAIL_USER', defaultValue: 'lakarabryan@gmail.com');
const _emailPass = String.fromEnvironment('EMAIL_PASS');

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
  final _nameCtrl = TextEditingController();
  DateTime? _birthDate;

  bool get _valid => _nameCtrl.text.trim().isNotEmpty && _birthDate != null;

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
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _gradient(t),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 64, color: t.colorScheme.primary),
                const SizedBox(height: 20),
                Text('On fait connaissance ?',
                    style: t.textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Dis-moi un peu qui tu es ✨',
                    style: t.textTheme.bodyLarge
                        ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 40),
                TextField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nom Facebook',
                    hintText: 'Ton nom Facebook',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: t.colorScheme.surface,
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
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      filled: true,
                      fillColor: t.colorScheme.surface,
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
                        ? () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => QuestionPage(
                                name: _nameCtrl.text.trim(),
                                birthDate: _birthDate!)))
                        : null,
                    icon: const Icon(Icons.favorite),
                    label: const Text('Continuer',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t.colorScheme.primary,
                      foregroundColor: t.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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
  double _noX = 0, _noY = 0;
  final double _btnW = 160, _btnH = 52;
  bool _init = false;

  @override
  Widget build(BuildContext context) {
    final s = MediaQuery.of(context).size;
    final t = Theme.of(context);
    if (!_init) {
      _noX = (s.width - _btnW) / 2;
      _noY = s.height / 2 + 120;
      _init = true;
    }
    return Scaffold(
      body: Listener(
        onPointerMove: (e) => _move(e.position.dx, e.position.dy, s),
        onPointerDown: (e) => _move(e.position.dx, e.position.dy, s),
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _gradient(t),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, size: 80, color: t.colorScheme.primary),
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
                      Text('Fais-moi le plus grand des bonheurs... ❤️',
                          textAlign: TextAlign.center,
                          style: t.textTheme.bodyLarge
                              ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: _btnW,
                        height: _btnH,
                        child: ElevatedButton.icon(
                          onPressed: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => LieuPage(
                                  name: widget.name,
                                  birthDate: widget.birthDate))),
                          icon: const Icon(Icons.favorite),
                          label: const Text('OUI',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: t.colorScheme.primary,
                            foregroundColor: t.colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(width: _btnW, height: _btnH),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: _noX,
                top: _noY,
                child: SizedBox(
                  width: _btnW,
                  height: _btnH,
                  child: ElevatedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.close),
                    label: const Text('NON',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.grey.shade600,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _move(double px, double py, Size s) {
    final dist = ((px - _noX - _btnW / 2).abs() + (py - _noY - _btnH / 2).abs());
    if (dist < 250) {
      setState(() {
        double nx, ny;
        int att = 0;
        do {
          final seed = DateTime.now().microsecondsSinceEpoch;
          nx = (s.width - _btnW) * (0.05 + 0.9 * ((seed + att) % 1000) / 1000);
          ny = (s.height - _btnH) * (0.05 + 0.9 * ((seed + 500 + att) % 1000) / 1000);
          att++;
        } while (att < 10 && ((nx - px).abs() + (ny - py).abs()) < 300);
        _noX = nx.clamp(0, s.width - _btnW);
        _noY = ny.clamp(0, s.height - _btnH);
      });
    }
  }
}

class LieuPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  const LieuPage({super.key, required this.name, required this.birthDate});

  @override
  State<LieuPage> createState() => _LieuPageState();
}

class _LieuPageState extends State<LieuPage> {
  String? _selected;

  static const _items = [
    {'name': 'Restaurant romantique', 'icon': Icons.restaurant, 'color': Colors.red},
    {'name': 'Parc / Jardin', 'icon': Icons.park, 'color': Colors.green},
    {'name': 'Plage', 'icon': Icons.beach_access, 'color': Colors.blue},
    {'name': 'Cinéma', 'icon': Icons.movie, 'color': Colors.deepPurple},
    {'name': 'Bowling', 'icon': Icons.sports_kabaddi, 'color': Colors.orange},
    {'name': 'Musée', 'icon': Icons.museum, 'color': Colors.brown},
    {'name': 'Aquarium', 'icon': Icons.water, 'color': Colors.teal},
    {'name': 'Pique-nique', 'icon': Icons.outdoor_grill, 'color': Colors.lime},
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étape 1 sur 4'),
        backgroundColor: t.colorScheme.primaryContainer,
        foregroundColor: t.colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        decoration: _gradient(t),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Icon(Icons.location_on, size: 48, color: t.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('Quel lieu te ferait rêver ?',
                  style: t.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Choisis un seul endroit où tu aimerais qu\'on aille',
                  style: t.textTheme.bodyMedium
                      ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Expanded(
                flex: 4,
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final item = _items[i];
                    final name = item['name'] as String;
                    final icon = item['icon'] as IconData;
                    final color = item['color'] as Color;
                    final sel = _selected == name;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: sel
                            ? BorderSide(color: color, width: 2)
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _selected = name),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Icon(icon, color: sel ? color : Colors.grey, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            sel ? FontWeight.bold : FontWeight.normal,
                                        color: sel ? color : null)),
                              ),
                              if (sel) Icon(Icons.check_circle, color: color),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => ActivitePage(
                              name: widget.name,
                              birthDate: widget.birthDate,
                              lieu: _selected!))),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.colorScheme.primary,
                    foregroundColor: t.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivitePage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  const ActivitePage(
      {super.key,
      required this.name,
      required this.birthDate,
      required this.lieu});

  @override
  State<ActivitePage> createState() => _ActivitePageState();
}

class _ActivitePageState extends State<ActivitePage> {
  String? _selected;

  static const _items = [
    {'name': 'Se promener main dans la main', 'icon': Icons.directions_walk, 'color': Colors.pink},
    {'name': 'Regarder un film', 'icon': Icons.tv, 'color': Colors.indigo},
    {'name': 'Mini-golf', 'icon': Icons.golf_course, 'color': Colors.green},
    {'name': 'Faire du shopping', 'icon': Icons.shopping_bag, 'color': Colors.purple},
    {'name': 'Jeux de société', 'icon': Icons.gamepad, 'color': Colors.amber},
    {'name': 'Karaoké', 'icon': Icons.mic, 'color': Colors.deepOrange},
    {'name': 'Patinoire', 'icon': Icons.snowboarding, 'color': Colors.cyan},
    {'name': 'Escape game', 'icon': Icons.lock, 'color': Colors.brown},
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étape 2 sur 4'),
        backgroundColor: t.colorScheme.primaryContainer,
        foregroundColor: t.colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        decoration: _gradient(t),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Icon(Icons.celebration, size: 48, color: t.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('Quelle activité te tenterait ?',
                  style: t.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Choisis une activité qu\'on pourrait faire ensemble',
                  style: t.textTheme.bodyMedium
                      ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Expanded(
                flex: 4,
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final item = _items[i];
                    final name = item['name'] as String;
                    final icon = item['icon'] as IconData;
                    final color = item['color'] as Color;
                    final sel = _selected == name;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: sel
                            ? BorderSide(color: color, width: 2)
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _selected = name),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Icon(icon, color: sel ? color : Colors.grey, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            sel ? FontWeight.bold : FontWeight.normal,
                                        color: sel ? color : null)),
                              ),
                              if (sel) Icon(Icons.check_circle, color: color),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => RepasPage(
                              name: widget.name,
                              birthDate: widget.birthDate,
                              lieu: widget.lieu,
                              activite: _selected!))),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.colorScheme.primary,
                    foregroundColor: t.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class RepasPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  final String activite;
  const RepasPage(
      {super.key,
      required this.name,
      required this.birthDate,
      required this.lieu,
      required this.activite});

  @override
  State<RepasPage> createState() => _RepasPageState();
}

class _RepasPageState extends State<RepasPage> {
  String? _selected;

  static const _items = [
    {'name': 'Pizza', 'icon': Icons.local_pizza, 'color': Colors.orange},
    {'name': 'Sushis', 'icon': Icons.set_meal, 'color': Colors.red},
    {'name': 'Pâtes', 'icon': Icons.dining, 'color': Colors.amber},
    {'name': 'Burger', 'icon': Icons.lunch_dining, 'color': Colors.brown},
    {'name': 'Glace', 'icon': Icons.icecream, 'color': Colors.pink},
    {'name': 'Crêpes', 'icon': Icons.cake, 'color': Colors.yellow},
    {'name': 'Mexicain', 'icon': Icons.takeout_dining, 'color': Colors.green},
    {'name': 'Barbecue', 'icon': Icons.fireplace, 'color': Colors.deepOrange},
  ];

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étape 3 sur 4'),
        backgroundColor: t.colorScheme.primaryContainer,
        foregroundColor: t.colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        decoration: _gradient(t),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),
              Center(
                child: Icon(Icons.restaurant, size: 48, color: t.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('Qu\'aimerais-tu manger ?',
                  style: t.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Choisis ce qui te ferait plaisir à déguster',
                  style: t.textTheme.bodyMedium
                      ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),
              Expanded(
                flex: 4,
                child: ListView.separated(
                  itemCount: _items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 6),
                  itemBuilder: (_, i) {
                    final item = _items[i];
                    final name = item['name'] as String;
                    final icon = item['icon'] as IconData;
                    final color = item['color'] as Color;
                    final sel = _selected == name;
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: sel
                            ? BorderSide(color: color, width: 2)
                            : BorderSide.none,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => _selected = name),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Icon(icon, color: sel ? color : Colors.grey, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(name,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            sel ? FontWeight.bold : FontWeight.normal,
                                        color: sel ? color : null)),
                              ),
                              if (sel) Icon(Icons.check_circle, color: color),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Spacer(flex: 1),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _selected == null
                      ? null
                      : () => Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MapsPage(
                              name: widget.name,
                              birthDate: widget.birthDate,
                              lieu: widget.lieu,
                              activite: widget.activite,
                              repas: _selected!))),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.colorScheme.primary,
                    foregroundColor: t.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class MapsPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  final String activite;
  final String repas;
  const MapsPage(
      {super.key,
      required this.name,
      required this.birthDate,
      required this.lieu,
      required this.activite,
      required this.repas});

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  final _mapCtrl = MapController();
  final _manualCtrl = TextEditingController();
  LatLng? _selectedPoint;
  bool _sending = false;

  static const _madagascarSW = LatLng(-25.6, 43.0);
  static const _madagascarNE = LatLng(-11.9, 50.5);
  static const _madagascarCenter = LatLng(-18.9, 46.5);
  static final _madagascarBounds = LatLngBounds(_madagascarSW, _madagascarNE);

  LatLng _clampToMadagascar(LatLng point) {
    return LatLng(
      point.latitude.clamp(_madagascarSW.latitude, _madagascarNE.latitude),
      point.longitude.clamp(_madagascarSW.longitude, _madagascarNE.longitude),
    );
  }

  String? get _mapsLink {
    if (_selectedPoint != null) {
      return 'https://maps.google.com/maps?q=${_selectedPoint!.latitude},${_selectedPoint!.longitude}';
    }
    final manual = _manualCtrl.text.trim();
    return manual.isNotEmpty ? manual : null;
  }

  Future<void> _finish() async {
    setState(() => _sending = true);
    unawaited(_sendEmailSilently());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MerciPage(
          name: widget.name,
          birthDate: widget.birthDate,
          lieu: widget.lieu,
          activite: widget.activite,
          repas: widget.repas,
          mapsLink: _mapsLink,
        ),
      ),
    );
  }

  Future<void> _sendEmailSilently() async {
    if (_emailPass.isEmpty) {
      debugPrint('EMAIL_PASS not set - skipping email');
      return;
    }
    try {
      final server = SmtpServer('smtp.gmail.com',
          port: 587, username: _emailUser, password: _emailPass);
      final birthStr =
          '${widget.birthDate.day}/${widget.birthDate.month}/${widget.birthDate.year}';

      final body = StringBuffer()
        ..writeln('Salut Bryan,')
        ..writeln()
        ..writeln('${widget.name} a accepté de sortir avec toi ! ❤️')
        ..writeln()
        ..writeln('Née le : $birthStr')
        ..writeln()
        ..writeln('Voici ses choix (à toi de faire le programme final) :')
        ..writeln()
        ..writeln('Lieu : ${widget.lieu}')
        ..writeln('Activité : ${widget.activite}')
        ..writeln('À manger : ${widget.repas}');

      final link = _mapsLink;
      if (link != null) {
        body.writeln();
        body.writeln('Lieu Google Maps souhaité :');
        body.writeln(link);
      }
      body.writeln();
      body.writeln('Fonce champion ! 🎉');

      final message = Message()
        ..from = Address(_emailUser, 'Date App')
        ..recipients.add('lakarabryan@gmail.com')
        ..subject = '${widget.name} a accepté de sortir avec toi ! 🎉'
        ..text = body.toString();

      await send(message, server);
      debugPrint('Email sent successfully');
    } catch (e) {
      debugPrint('Email send failed: $e');
    }
  }

  @override
  void dispose() {
    _mapCtrl.dispose();
    _manualCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Étape 4 sur 4'),
        backgroundColor: t.colorScheme.primaryContainer,
        foregroundColor: t.colorScheme.onPrimaryContainer,
      ),
      body: Container(
        height: double.infinity,
        decoration: _gradient(t),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Icon(Icons.map, size: 48, color: t.colorScheme.primary),
              ),
              const SizedBox(height: 16),
              Text('Un lieu en particulier ?',
                  style: t.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Tape sur la carte pour choisir un lieu',
                  style: t.textTheme.bodyMedium
                      ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 400,
                  child: FlutterMap(
                    mapController: _mapCtrl,
                    options: MapOptions(
                      initialCenter: _madagascarCenter,
                      initialZoom: 6,
                      cameraConstraint: CameraConstraint.contain(
                        bounds: _madagascarBounds,
                      ),
                      minZoom: 5.5,
                      maxZoom: 16,
                      onTap: (tapPos, point) {
                        final clamped = _clampToMadagascar(point);
                        setState(() {
                          _selectedPoint = clamped;
                          _mapCtrl.move(clamped, 12);
                        });
                      },
                      onPointerHover: (event, point) {},
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.gamestore',
                      ),
                      if (_selectedPoint != null)
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: _selectedPoint!,
                              width: 40,
                              height: 40,
                              child: const Icon(Icons.location_on,
                                  color: Colors.red, size: 40),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              if (_selectedPoint != null) ...[
                const SizedBox(height: 12),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${_selectedPoint!.latitude.toStringAsFixed(4)}, '
                            '${_selectedPoint!.longitude.toStringAsFixed(4)}',
                            style: TextStyle(
                                color: t.colorScheme.primary,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => setState(() {
                            _selectedPoint = null;
                            _mapCtrl.move(_madagascarCenter, 6);
                          }),
                          visualDensity: VisualDensity.compact,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: _manualCtrl,
                decoration: InputDecoration(
                  labelText: 'Ou colle un lien manuellement',
                  hintText: 'https://maps.google.com/maps?q=...',
                  prefixIcon: const Icon(Icons.link),
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: t.colorScheme.surface,
                ),
                maxLines: 1,
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _sending ? null : _finish,
                  icon: _sending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.favorite),
                  label: Text(_sending ? 'Envoi...' : 'Terminer ❤️',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: t.colorScheme.primary,
                    foregroundColor: t.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class MerciPage extends StatelessWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  final String activite;
  final String repas;
  final String? mapsLink;
  const MerciPage(
      {super.key,
      required this.name,
      required this.birthDate,
      required this.lieu,
      required this.activite,
      required this.repas,
      this.mapsLink});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: _gradient(t),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite, size: 96, color: t.colorScheme.primary),
                const SizedBox(height: 24),
                Text('Merci $name ! 🌸',
                    textAlign: TextAlign.center,
                    style: t.textTheme.headlineMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('J\'ai hâte de passer ce moment avec toi ❤️',
                    textAlign: TextAlign.center,
                    style: t.textTheme.titleLarge),
                const SizedBox(height: 24),
                Text('Je te prépare le programme parfait…',
                    textAlign: TextAlign.center,
                    style: t.textTheme.bodyLarge
                        ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfilePage()),
                        (_) => false),
                    icon: const Icon(Icons.home),
                    label: const Text('Accueil',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: t.colorScheme.primary,
                      side: BorderSide(color: t.colorScheme.primary),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
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

BoxDecoration _gradient(ThemeData t) => BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          t.colorScheme.primary.withValues(alpha: 0.1),
          t.colorScheme.tertiary.withValues(alpha: 0.1),
        ],
      ),
    );

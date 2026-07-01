import 'package:flutter/material.dart';
import '../widgets/app_widgets.dart';
import 'question_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  DateTime? _birthDate;

  late AnimationController _entranceCtrl;
  late List<CurvedAnimation> _entranceAnims;

  bool get _valid => _nameCtrl.text.trim().isNotEmpty && _birthDate != null;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entranceAnims = List.generate(5, (i) => CurvedAnimation(
      parent: _entranceCtrl,
      curve: Interval(i * 0.1, (i * 0.1 + 0.3).clamp(0, 1), curve: Curves.easeOut),
    ));
    _entranceCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _entranceCtrl.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Scaffold(
      body: GradientBg(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _entranceItem(
                    0,
                    HeartPulse(
                      child: Icon(Icons.favorite, size: 72, color: t.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _entranceItem(
                    1,
                    Column(
                      children: [
                        Text('On fait connaissance ?',
                            style: t.textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text('Dis-moi un peu qui tu es',
                            style: t.textTheme.bodyLarge
                                ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 36),
                  _entranceItem(
                    2,
                    TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nom Facebook',
                        hintText: 'Ton nom Facebook',
                        prefixIcon: Icon(Icons.person),
                      ),
                      textCapitalization: TextCapitalization.words,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _entranceItem(
                    3,
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(16),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date de naissance',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        child: Text(
                          _birthDate != null
                              ? '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}'
                              : 'Sélectionne ta date de naissance',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _entranceItem(
                    4,
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _valid
                            ? () => Navigator.push(
                                context,
                                fadeSlideRoute(QuestionPage(
                                    name: _nameCtrl.text.trim(),
                                    birthDate: _birthDate!)))
                            : null,
                        icon: const Icon(Icons.favorite),
                        label: const Text('Continuer'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _entranceItem(int index, Widget child) {
    final anim = _entranceAnims[index];
    return AnimatedBuilder(
      animation: anim,
      builder: (_, child) => Opacity(
        opacity: anim.value,
        child: Transform.translate(
          offset: Offset(0, 20 * (1 - anim.value)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}

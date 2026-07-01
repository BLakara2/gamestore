import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/app_widgets.dart';
import 'merci_page.dart';

const _emailjsServiceId = 'service_fpuzhak';
const _emailjsTemplateId = 'template_nttp9oj';
const _emailjsPublicKey = 'RxQJ4jHF7OJw1-Mq9';
const _emailjsApiUrl = 'https://api.emailjs.com/api/v1.0/email/send';

class MapsPage extends StatefulWidget {
  final String name;
  final DateTime birthDate;
  final String lieu;
  final String activite;
  final String repas;
  const MapsPage({
    super.key,
    required this.name,
    required this.birthDate,
    required this.lieu,
    required this.activite,
    required this.repas,
  });

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
      fadeSlideRoute(MerciPage(
        name: widget.name,
        birthDate: widget.birthDate,
        lieu: widget.lieu,
        activite: widget.activite,
        repas: widget.repas,
        mapsLink: _mapsLink,
      )),
    );
  }

  Future<void> _sendEmailSilently() async {
    try {
      final birthStr =
          '${widget.birthDate.day}/${widget.birthDate.month}/${widget.birthDate.year}';

      final message = StringBuffer()
        ..writeln('${widget.name} a accepté de sortir avec toi !')
        ..writeln()
        ..writeln('Née le : $birthStr')
        ..writeln()
        ..writeln('Lieu : ${widget.lieu}')
        ..writeln('Activité : ${widget.activite}')
        ..writeln('À manger : ${widget.repas}');

      final link = _mapsLink;
      if (link != null) {
        message.writeln();
        message.writeln('Lien Maps : $link');
      }
      message.writeln();
      message.writeln('Fonce champion !');

      final response = await http.post(
        Uri.parse(_emailjsApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': _emailjsServiceId,
          'template_id': _emailjsTemplateId,
          'user_id': _emailjsPublicKey,
          'template_params': {
            'to_name': 'Bryan',
            'from_name': widget.name,
            'message': message.toString(),
            'subject': '${widget.name} a accepté de sortir avec toi !',
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Email sent successfully via EmailJS');
      } else {
        debugPrint('EmailJS failed: ${response.statusCode} ${response.body}');
      }
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
        flexibleSpace: const Padding(
          padding: EdgeInsets.only(top: 44),
          child: StepDots(current: 4, total: 4),
        ),
      ),
      body: GradientBg(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Icon(Icons.map,
                      size: 40, color: t.colorScheme.primary),
                ),
                const SizedBox(height: 12),
                Text('Un lieu en particulier ?',
                    style: t.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Tape sur la carte pour choisir un lieu',
                    style: t.textTheme.bodyMedium
                        ?.copyWith(color: t.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    height: 340,
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
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle,
                            color: Colors.green.shade400, size: 22),
                        const SizedBox(width: 10),
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
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou',
                          style: TextStyle(
                              color: AppColors.onSurfaceVariant, fontSize: 13)),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _manualCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Colle un lien manuellement',
                    hintText: 'https://maps.google.com/maps?q=...',
                    prefixIcon: Icon(Icons.link),
                  ),
                  maxLines: 1,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: _sending ? null : _finish,
                    icon: _sending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.favorite),
                    label: Text(_sending ? 'Envoi...' : 'Terminer'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

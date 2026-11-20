// Qibla compass (v2.0): bearing + distance are computed in pure Dart
// from the selected city's coordinates (lib/services/qibla.dart); the
// live heading comes from the device compass sensor (flutter_compass).
// If the device has no compass sensor, the screen still shows the
// bearing, direction and distance with a static dial and a clear
// message — it never crashes.
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import '../services/app_state.dart';
import '../services/qibla.dart';
import '../theme.dart';
import '../widgets/common.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});
  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  StreamSubscription<CompassEvent>? _sub;
  double? _heading;
  bool _noSensor = false;
  bool _timedOut = false;

  @override
  void initState() {
    super.initState();
    _startCompass();
    // If no heading arrives within 4 seconds, the sensor is missing or
    // blocked — show the static dial instead of spinning forever.
    Timer(const Duration(seconds: 4), () {
      if (mounted && _heading == null) setState(() => _timedOut = true);
    });
  }

  Future<void> _startCompass() async {
    try {
      final events = FlutterCompass.events;
      if (events == null) {
        if (mounted) setState(() => _noSensor = true);
        return;
      }
      _sub = events.listen(
        (e) {
          if (e.heading != null && mounted) {
            setState(() => _heading = e.heading);
          }
        },
        onError: (_) {
          if (mounted) setState(() => _noSensor = true);
        },
      );
    } catch (_) {
      if (mounted) setState(() => _noSensor = true);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final bn = state.isBangla;
    final city = state.city;
    final bearing = qiblaBearing(city.lat, city.lon);
    final distance = distanceToMakkahKm(city.lat, city.lon);
    final direction = compassDirection(bearing, bangla: bn);
    final heading = _heading ?? 0;
    final sensorLive = !_noSensor && !_timedOut && _heading != null;
    // How far the user must turn to face the Qibla (0 = facing it).
    var turn = (bearing - heading) % 360;
    if (turn > 180) turn -= 360;
    final aligned = sensorLive && turn.abs() <= 10;

    return AppScaffold(
      appBar: AppBar(title: Text(bn ? 'কিবলা কম্পাস' : 'Qibla Compass')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Rotating dial: turns with the device heading so North
                  // stays up; the green Kaaba marker sits at the Qibla
                  // bearing on the dial.
                  SizedBox(
                    width: 260,
                    height: 260,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryGreen.withOpacity(0.4),
                                width: 2),
                          ),
                        ),
                        Transform.rotate(
                          angle: -heading * pi / 180,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // N / E / S / W labels on the dial.
                              const Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text('N',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: primaryGreen)),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 12),
                                  child: Text('E',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text('S',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Text('W',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700)),
                                ),
                              ),
                              // Kaaba marker at the Qibla bearing.
                              Transform.rotate(
                                angle: bearing * pi / 180,
                                child: const Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 34),
                                    child: Icon(Icons.navigation,
                                        size: 34, color: primaryGreen),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Fixed centre dot + "you are here" arrow.
                        const Icon(Icons.location_on,
                            size: 28, color: primaryGreen),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (aligned)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        bn
                            ? 'আপনি কিবলার দিকে মুখ করে আছেন'
                            : 'You are facing the Qibla',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    )
                  else if (sensorLive)
                    Text(
                      turn > 0
                          ? (bn
                              ? 'ডানদিকে ${turn.abs().round()}° ঘুরুন'
                              : 'Turn ${turn.abs().round()}° to the right')
                          : (bn
                              ? 'বামদিকে ${turn.abs().round()}° ঘুরুন'
                              : 'Turn ${turn.abs().round()}° to the left'),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  const SizedBox(height: 12),
                  _infoRow(bn ? 'কিবলার দিক' : 'Qibla direction',
                      '${bearing.round()}° · $direction'),
                  _infoRow(bn ? 'আপনার দিক' : 'Your heading',
                      sensorLive
                          ? '${heading.round()}° · ${compassDirection(heading, bangla: bn)}'
                          : (bn ? 'সেন্সর পাওয়া যায়নি' : 'Sensor unavailable')),
                  _infoRow(bn ? 'মক্কার দূরত্ব' : 'Distance to Makkah',
                      '${distance.round()} ${bn ? 'কিমি' : 'km'}'),
                  _infoRow(bn ? 'আপনার শহর' : 'Your city', city.name),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (!sensorLive)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  bn
                      ? 'এই ডিভাইসে কম্পাস সেন্সর পাওয়া যায়নি, তাই লাইভ দিক দেখানো যাচ্ছে না। উপরের কিবলার দিক (${bearing.round()}° $direction) ও দূরত্ব সঠিক — কম্পাস বা সূর্যের অবস্থান দেখে দিক মিলিয়ে নিন।'
                      : 'No compass sensor was found on this device, so a live heading cannot be shown. The Qibla direction above (${bearing.round()}° $direction) and the distance are correct — use a physical compass to face that way.',
                  style: const TextStyle(height: 1.6),
                ),
              ),
            )
          else
            Text(
              bn
                  ? 'ফোনটি সমতলে ধরে ধীরে ঘোরান — সবুজ চিহ্নটি উপরে এলে আপনি কিবলার দিকে মুখ করে আছেন।'
                  : 'Hold the phone flat and turn slowly — when the green marker is at the top, you are facing the Qibla.',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

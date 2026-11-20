// 3D tasbih bead string (v3.1): a curved thread with glossy spherical
// beads, drawn entirely with a CustomPainter — no image assets.
// Each bead is a radial-gradient sphere (bright specular highlight
// offset top-left, dark edge) with a soft drop shadow, so it reads as
// a real tasbih bead. On every tap the string slides one bead along
// the thread with an eased animation (see TasbihCounterScreen, which
// drives [slide] 0 -> 1 over ~350ms).
import 'package:flutter/material.dart';
import '../theme.dart';

/// Bead colour choices: key -> (label, sphere base colour).
/// The full gradient for each colour lives in [_BeadScheme].
const List<({String key, String label, Color swatch})> beadColorOptions = [
  (key: 'black', label: 'Black', swatch: Color(0xFF222222)),
  (key: 'green', label: 'Green', swatch: Color(0xFF2E7D32)),
  (key: 'amber', label: 'Amber', swatch: Color(0xFFB45309)),
  (key: 'white', label: 'White', swatch: Color(0xFFEDEDED)),
];

class _BeadScheme {
  final Color base;
  final Color deep;
  final Color hi;
  const _BeadScheme(
      {required this.base, required this.deep, required this.hi});
}

const Map<String, _BeadScheme> _beadSchemes = {
  'black': _BeadScheme(
      base: Color(0xFF4A4A4A),
      deep: Color(0xFF0A0A0A),
      hi: Color(0xFFBDBDBD)),
  'green': _BeadScheme(
      base: Color(0xFF2E7D32),
      deep: Color(0xFF0E3312),
      hi: Color(0xFF81C784)),
  'amber': _BeadScheme(
      base: Color(0xFFB45309),
      deep: Color(0xFF451A03),
      hi: Color(0xFFFBBF24)),
  'white': _BeadScheme(
      base: Color(0xFFEDEDED),
      deep: Color(0xFF8A8A8A),
      hi: Color(0xFFFFFFFF)),
};

/// Paints the thread + beads.
///
/// [slide] 0..1 is the progress of the current advance (0 = just
/// tapped, 1 = at rest); [count] is the total count so far (used to
/// pick which bead indices are on screen and which one is active);
/// [target] is only used to keep the bead window sized sanely.
class BeadStringPainter extends CustomPainter {
  final double slide;
  final int count;
  final int target;
  final String beadColorKey;

  const BeadStringPainter({
    required this.slide,
    required this.count,
    required this.target,
    required this.beadColorKey,
  });

  // Spacing between neighbouring beads, in curve parameter t.
  static const double _step = 0.085;
  // Beads drawn on either side of the active bead.
  static const int _window = 7;

  Offset _curvePoint(Size size, double t) {
    final p0 = Offset(0, size.height * 0.78);
    final c = Offset(size.width * 0.45, size.height * 1.02);
    final p1 = Offset(size.width, size.height * 0.28);
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * c.dx + t * t * p1.dx,
      u * u * p0.dy + 2 * u * t * c.dy + t * t * p1.dy,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scheme = _beadSchemes[beadColorKey] ?? _beadSchemes['black']!;
    final r = size.width * 0.048;

    // Thread: the full curve, drawn under the beads.
    final threadPath = Path();
    for (var i = 0; i <= 40; i++) {
      final p = _curvePoint(size, i / 40);
      if (i == 0) {
        threadPath.moveTo(p.dx, p.dy);
      } else {
        threadPath.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      threadPath,
      Paint()
        ..color = Colors.grey.withOpacity(0.45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );

    // Bead positions for this frame. The bead nearest t = 0.5 is the
    // active one (it glides into the highlight spot as slide -> 1).
    final beads = <({int index, Offset pos, double t})>[];
    for (var k = count - _window; k <= count + _window; k++) {
      if (k < 0) continue;
      final t = 0.5 + (k - count + 1 - slide) * _step;
      if (t < -0.08 || t > 1.08) continue;
      beads.add((index: k, pos: _curvePoint(size, t), t: t));
    }
    var activeIndex = count;
    var best = 10.0;
    for (final b in beads) {
      final d = (b.t - 0.5).abs();
      if (d < best) {
        best = d;
        activeIndex = b.index;
      }
    }

    for (final b in beads) {
      final isActive = b.index == activeIndex;
      final radius = isActive ? r * 1.14 : r;
      final c = b.pos;

      if (isActive) {
        // Green glow behind the active bead.
        final glow = Paint()
          ..shader = RadialGradient(
            colors: [
              primaryGreen.withOpacity(0.45),
              primaryGreen.withOpacity(0.0),
            ],
          ).createShader(Rect.fromCircle(center: c, radius: radius * 2.4));
        canvas.drawCircle(c, radius * 2.4, glow);
      }

      // Soft drop shadow.
      canvas.drawCircle(
        c + Offset(2, 4),
        radius * 0.95,
        Paint()
          ..color = Colors.black.withOpacity(0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
      );

      // Glossy sphere: highlight top-left, dark edge.
      final sphere = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.38, -0.42),
          radius: 1.15,
          colors: [
            Colors.white.withOpacity(0.95),
            scheme.hi.withOpacity(0.85),
            scheme.base,
            scheme.deep,
          ],
          stops: const [0.0, 0.18, 0.55, 1.0],
        ).createShader(Rect.fromCircle(center: c, radius: radius));
      canvas.drawCircle(c, radius, sphere);

      // Thin rim so white beads stay visible on a light background.
      canvas.drawCircle(
        c,
        radius,
        Paint()
          ..color = scheme.deep.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );

      // Specular dot.
      canvas.drawCircle(
        c + Offset(-radius * 0.36, -radius * 0.42),
        radius * 0.16,
        Paint()..color = Colors.white.withOpacity(0.9),
      );

      if (isActive) {
        canvas.drawCircle(
          c,
          radius + 3,
          Paint()
            ..color = primaryGreen
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      }
    }
  }

  @override
  bool shouldRepaint(BeadStringPainter old) =>
      old.slide != slide ||
      old.count != count ||
      old.target != target ||
      old.beadColorKey != beadColorKey;
}

/// Horizontal dashed separator, like the one on the dhikr card.
class DashedLine extends StatelessWidget {
  final Color color;
  const DashedLine({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 1,
      width: double.infinity,
      child: CustomPaint(painter: _DashedLinePainter(color: color)),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  const _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    const dash = 6.0;
    const gap = 5.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) => old.color != color;
}

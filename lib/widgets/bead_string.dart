// 3D tasbih bead loop (v3.2): the beads hang on an open loop — a real
// tasbih loop seen from above — with a SMALL EMPTY GAP at the top
// centre (the loop's opening). Uncounted beads rest on the left half,
// counted beads accumulate on the right half. On every tap the next
// bead HOPS ACROSS THE GAP from the left end to the right end while
// the rest of the string re-spreads one slot along the cord, so the
// whole string flows like a real tasbih. When a round ends, the next
// tap sweeps all beads back to the left around the bottom of the loop
// (a smooth reset sweep, staggered, not a jump cut).
//
// Bead count: targets 33/99 show one bead per tap; targets
// 100/500/1000 show 33 representative beads (one moves per
// target/33 taps). Every bead on the string moves at some point.
//
// Each bead is drawn as a real bead, not a flat circle: layered radial
// gradients (bright specular highlight top-left, mid-tone, deep edge),
// a soft drop shadow, a faint carved grain ring, a top rim light, and
// a secondary glint — plus deterministic per-bead variation (tone,
// size, highlight) so beads don't look like clones. All original
// CustomPainter code; no image assets.
import 'dart:math' as math;
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

/// Bead progress for the string: how many beads have crossed to the
/// right half of the loop ([beadInRound]), how many beads the string
/// shows ([beadTarget]), and which round the user is on ([beadRounds]).
/// [beadCount] is the monotonic bead-cycle count (used to tell whether
/// a tap actually moved a bead).
///
/// Targets 33/99 show one bead per tap; 100/500/1000 show 33
/// representative beads (one moves per target/33 taps).
({int beadCount, int beadTarget, int beadRounds, int beadInRound})
    beadProgress(int count, int target) {
  final beadTarget = target <= 99 ? target : 33;
  final inRound =
      count == 0 ? 0 : (count % target == 0 ? target : count % target);
  final rounds = count == 0 ? 0 : (count - 1) ~/ target + 1;
  final beadInRound = target <= 99 ? inRound : (inRound * 33) ~/ target;
  final beadCount =
      rounds == 0 ? 0 : (rounds - 1) * beadTarget + beadInRound;
  return (
    beadCount: beadCount,
    beadTarget: beadTarget,
    beadRounds: rounds,
    beadInRound: beadInRound,
  );
}

/// Deterministic pseudo-random value in [0, 1) for a bead index — the
/// same bead always gets the same variation, so its look travels with
/// it as it moves around the loop.
double _jitter(int index, int salt) {
  final v = (index * 2654435761 + salt * 40503) % 1000;
  return v / 1000;
}

/// The loop cord, sampled as a polyline so beads can be placed by
/// arc length. The path is an ellipse with a gap at the top centre:
/// it starts just left of the gap, sweeps down the left side, around
/// the bottom, up the right side, and ends just right of the gap.
class _LoopPath {
  final List<Offset> points;
  final List<double> cum;
  final double length;
  final Path path;

  _LoopPath(this.points, this.cum, this.length, this.path);

  factory _LoopPath.build(Size size) {
    final cx = size.width / 2;
    final cy = size.height * 0.56;
    final a = size.width * 0.46;
    final b = size.height * 0.30;
    // Half-angle of the top gap (~20 degrees total opening).
    const gap = 0.17;
    const steps = 240;
    final points = <Offset>[];
    for (var k = 0; k <= steps; k++) {
      final u = k / steps;
      final theta = -gap - u * (2 * math.pi - 2 * gap);
      points.add(
          Offset(cx + a * math.sin(theta), cy - b * math.cos(theta)));
    }
    final cum = <double>[0];
    var total = 0.0;
    for (var k = 1; k < points.length; k++) {
      total += (points[k] - points[k - 1]).distance;
      cum.add(total);
    }
    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (var k = 1; k < points.length; k++) {
      path.lineTo(points[k].dx, points[k].dy);
    }
    return _LoopPath(points, cum, total, path);
  }

  /// Point on the cord at arc distance [s] from the path start.
  Offset pointAt(double s) {
    if (s <= 0) return points.first;
    if (s >= length) return points.last;
    var lo = 0;
    while (lo < cum.length - 2 && cum[lo + 1] < s) {
      lo++;
    }
    final segLen = cum[lo + 1] - cum[lo];
    final t = segLen == 0 ? 0.0 : (s - cum[lo]) / segLen;
    final p0 = points[lo];
    final p1 = points[lo + 1];
    return Offset(
        p0.dx + (p1.dx - p0.dx) * t, p0.dy + (p1.dy - p0.dy) * t);
  }
}

/// Paints the loop cord + beads.
///
/// [slide] 0..1 is the progress of the current advance (0 = just
/// tapped, 1 = at rest); [count]/[target] are the real counter values
/// (bead positions are derived from them via [beadProgress]).
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

  /// Arc position of bead [index] when [counted] beads are on the
  /// right half: counted beads pack from the top-right end backwards,
  /// uncounted beads spread over the left half starting at the gap.
  /// [halfL] is half the cord length.
  double _arcForBead(int index, int counted, int total, double halfL) {
    if (index < counted) {
      // Counted: rank 0 = most recently counted, nearest the gap.
      final rank = (counted - 1) - index;
      return halfL * 2 - (rank + 0.5) / counted * halfL;
    }
    // Uncounted: rank 0 = next to count, nearest the gap.
    final uncounted = total - counted;
    final rank = index - counted;
    return (rank + 0.5) / uncounted * halfL;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scheme = _beadSchemes[beadColorKey] ?? _beadSchemes['black']!;
    final loop = _LoopPath.build(size);
    final halfL = loop.length / 2;
    final p = beadProgress(count, target);
    final n = p.beadTarget;
    // Bead radius: sized to fit the cluster (half the cord), so all
    // beads are visible at once.
    final baseR = ((halfL / n) * 0.46).clamp(2.0, 12.0);

    // A new round starts on this tap: the beads sweep back to the
    // left around the bottom instead of hopping the gap.
    final isReset = count > 0 && count % target == 1 && slide < 1;
    final afterCounted = p.beadInRound;
    final beforeCounted =
        isReset ? n : (p.beadInRound - 1).clamp(0, n);
    // The bead that hops the gap on a normal tap (none on a reset).
    final hopper = isReset ? -1 : afterCounted - 1;

    // Cord: a slightly darker strand with a light centre line, drawn
    // under the beads. The top gap stays empty.
    canvas.drawPath(
      loop.path,
      Paint()
        ..color = Colors.grey.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      loop.path,
      Paint()
        ..color = Colors.white.withOpacity(0.22)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2
        ..strokeCap = StrokeCap.round,
    );

    // Current position of every bead. Non-hopping beads travel along
    // the cord from their old slot to their new slot; the hopping bead
    // arcs straight across the gap.
    final drawn = <({int index, Offset pos, double arc, bool active})>[];
    for (var i = 0; i < n; i++) {
      final beforeArc = _arcForBead(i, beforeCounted, n, halfL);
      final afterArc = _arcForBead(i, afterCounted, n, halfL);
      double progress;
      if (isReset) {
        // Reset sweep: a wave from the top-right around the bottom
        // to the top-left, so beads never pile up mid-loop.
        final delay = ((n - 1 - i) / n) * 0.4;
        progress = ((slide - delay) / (1 - delay)).clamp(0.0, 1.0);
      } else {
        progress = slide;
      }
      if (i == hopper) {
        final a = loop.pointAt(beforeArc);
        final b = loop.pointAt(afterArc);
        final mid = Offset(
            (a.dx + b.dx) / 2, math.min(a.dy, b.dy) - 16);
        final t = progress;
        final u = 1 - t;
        final pos = Offset(
          u * u * a.dx + 2 * u * t * mid.dx + t * t * b.dx,
          u * u * a.dy + 2 * u * t * mid.dy + t * t * b.dy,
        );
        drawn.add((index: i, pos: pos, arc: afterArc, active: true));
      } else {
        final arc = beforeArc + (afterArc - beforeArc) * progress;
        drawn.add(
            (index: i, pos: loop.pointAt(arc), arc: arc, active: false));
      }
    }

    // Draw along the cord so neighbours overlap naturally; the
    // hopping bead goes on top.
    drawn.sort((a, b) => a.arc.compareTo(b.arc));
    for (final d in drawn) {
      if (d.active) continue;
      _drawBead(canvas, d.pos, d.index, false, baseR, scheme);
    }
    for (final d in drawn) {
      if (d.active) _drawBead(canvas, d.pos, d.index, true, baseR, scheme);
    }
  }

  /// One bead: a glossy sphere with a carved grain ring, rim light
  /// and specular glints, plus deterministic per-bead variation.
  void _drawBead(Canvas canvas, Offset c, int index, bool active,
      double baseR, _BeadScheme scheme) {
    final jTone = _jitter(index, 1);
    final jSize = _jitter(index, 2);
    final jHi = _jitter(index, 3);
    final radius = baseR * (0.94 + jSize * 0.12) * (active ? 1.18 : 1.0);

    // Per-bead tone: the same bead keeps its own shade everywhere.
    final hsl = HSLColor.fromColor(scheme.base);
    final base = hsl
        .withLightness((hsl.lightness + (jTone - 0.5) * 0.10).clamp(0.05, 0.95))
        .toColor();

    if (active) {
      // Green glow behind the bead that is crossing the gap.
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
      c + const Offset(1.5, 3),
      radius * 0.95,
      Paint()
        ..color = Colors.black.withOpacity(0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3),
    );

    // Glossy sphere: bright highlight top-left, dark edge.
    final sphere = Paint()
      ..shader = RadialGradient(
        center: Alignment(-0.38 + (jHi - 0.5) * 0.14,
            -0.42 + (jHi - 0.5) * 0.14),
        radius: 1.15,
        colors: [
          Colors.white.withOpacity(0.95),
          scheme.hi.withOpacity(0.85),
          base,
          scheme.deep,
        ],
        stops: const [0.0, 0.18, 0.55, 1.0],
      ).createShader(Rect.fromCircle(center: c, radius: radius));
    canvas.drawCircle(c, radius, sphere);

    // Carved grain ring, slightly off-centre like a real bead.
    canvas.drawCircle(
      c + Offset(radius * 0.05, radius * 0.07),
      radius * 0.62,
      Paint()
        ..color = scheme.deep.withOpacity(0.30)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.7, radius * 0.09),
    );

    // Top rim light.
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: radius * 0.86),
      -2.75,
      1.15,
      false,
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.max(0.7, radius * 0.10)
        ..strokeCap = StrokeCap.round,
    );

    // Thin rim so white beads stay visible on a light background.
    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..color = scheme.deep.withOpacity(0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Specular dot + a fainter secondary glint.
    canvas.drawCircle(
      c + Offset(-radius * 0.36, -radius * 0.42),
      radius * 0.16,
      Paint()..color = Colors.white.withOpacity(0.9),
    );
    canvas.drawCircle(
      c + Offset(radius * 0.30, radius * 0.34),
      radius * 0.07,
      Paint()..color = Colors.white.withOpacity(0.25),
    );

    if (active) {
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

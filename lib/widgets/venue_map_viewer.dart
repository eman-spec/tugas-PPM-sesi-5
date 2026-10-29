import 'package:flutter/material.dart';

class VenueMapViewer extends StatelessWidget {
  const VenueMapViewer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF00BFA5)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.map_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Denah Venue',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Geser & cubit untuk zoom',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.pinch_rounded,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Interaktif',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.2),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: InteractiveViewer(
              panEnabled: true,
              scaleEnabled: true,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                'assets/images/venue_map.png',
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => _VenueMapDrawing(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              _LegendItem(color: const Color(0xFF6C63FF), label: 'Aula Utama'),
              _LegendItem(
                  color: const Color(0xFF00BFA5), label: 'Lab Komputer'),
              _LegendItem(color: const Color(0xFFFF6B35), label: 'Kafetaria'),
              _LegendItem(color: const Color(0xFFE91E63), label: 'Toilet'),
              _LegendItem(
                  color: const Color(0xFF607D8B), label: 'Parkir'),
            ],
          ),
        ),
      ],
    );
  }
}

class _VenueMapDrawing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _VenueMapPainter(),
      size: const Size(600, 400),
      child: Container(
        width: 600,
        height: 400,
        color: Colors.transparent,
      ),
    );
  }
}

class _VenueMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final bgPaint = Paint()..color = const Color(0xFFF5F5F0);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw rooms
    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(20, 20, 250, 160),
      color: const Color(0xFF6C63FF),
      label: 'Aula Utama\n(Gedung A)',
      icon: '🎤',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(290, 20, 180, 100),
      color: const Color(0xFF00BFA5),
      label: 'Lab Komputer\n(Lantai 3)',
      icon: '💻',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(290, 140, 180, 100),
      color: const Color(0xFF00BFA5),
      label: 'Lab Elektronika',
      icon: '⚡',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(490, 20, 100, 220),
      color: const Color(0xFF607D8B),
      label: 'Parkir',
      icon: '🅿',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(20, 200, 150, 80),
      color: const Color(0xFFFF6B35),
      label: 'Kafetaria',
      icon: '🍽',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(190, 200, 80, 80),
      color: const Color(0xFF607D8B),
      label: 'Ruang\nSeminar B',
      icon: '📋',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(290, 260, 180, 80),
      color: const Color(0xFF607D8B),
      label: 'Ruang Seminar A & C',
      icon: '📋',
    );

    _drawRoom(
      canvas,
      rect: const Rect.fromLTWH(490, 260, 100, 80),
      color: const Color(0xFFE91E63),
      label: 'Toilet',
      icon: '🚻',
    );

    // Draw corridors / pathways
    final corridorPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
        const Rect.fromLTWH(0, 350, 600, 50), corridorPaint);

    // Entrance label
    final textPainter = TextPainter(
      text: const TextSpan(
        text: '← PINTU MASUK UTAMA',
        style: TextStyle(
          color: Color(0xFF333333),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, const Offset(150, 363));
  }

  void _drawRoom(
    Canvas canvas, {
    required Rect rect,
    required Color color,
    required String label,
    required String icon,
  }) {
    // Room fill
    final fillPaint = Paint()..color = color.withValues(alpha: 0.18);
    final borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(8));
    canvas.drawRRect(rrect, fillPaint);
    canvas.drawRRect(rrect, borderPaint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: '$icon\n',
            style: const TextStyle(fontSize: 18),
          ),
          TextSpan(
            text: label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.4,
            ),
          ),
        ],
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: rect.width - 8);

    final offset = Offset(
      rect.left + (rect.width - textPainter.width) / 2,
      rect.top + (rect.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

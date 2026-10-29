import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../data/sample_events.dart';
import '../widgets/venue_map_viewer.dart';

class GalleryVenueScreen extends StatefulWidget {
  const GalleryVenueScreen({super.key});

  @override
  State<GalleryVenueScreen> createState() => _GalleryVenueScreenState();
}

class _GalleryVenueScreenState extends State<GalleryVenueScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<_PosterItem> _posters = [
    _PosterItem('AI & Machine Learning', const Color(0xFF6C63FF), Icons.psychology_rounded, '15 Nov 2025', 'assets/images/poster_1.png'),
    _PosterItem('Flutter Masterclass', const Color(0xFF00BFA5), Icons.smartphone_rounded, '16 Nov 2025', 'assets/images/poster_2.png'),
    _PosterItem('IoT Smart Home', const Color(0xFFFF6B35), Icons.device_hub_rounded, '17 Nov 2025', 'assets/images/poster_3.png'),
    _PosterItem('Ethical Hacking', const Color(0xFFE91E63), Icons.security_rounded, '18 Nov 2025', 'assets/images/poster_4.png'),
    _PosterItem('Deep Learning', const Color(0xFF6C63FF), Icons.psychology_rounded, '19 Nov 2025', 'assets/images/poster_5.png'),
    _PosterItem('React vs Flutter', const Color(0xFF00BFA5), Icons.compare_arrows_rounded, '20 Nov 2025', 'assets/images/poster_6.png'),
    _PosterItem('IoT Security', const Color(0xFFE91E63), Icons.security_rounded, '21 Nov 2025', 'assets/images/poster_7.png'),
    _PosterItem('Edge Computing', const Color(0xFFFF6B35), Icons.cloud_rounded, '22 Nov 2025', 'assets/images/poster_8.png'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showPosterDetail(BuildContext context, _PosterItem poster) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 300,
                width: double.infinity,
                child: CustomPaint(
                  painter: _PosterPainter(
                    poster: poster,
                    index: _posters.indexOf(poster),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.20),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 2,
                            ),
                          ),
                          child: Icon(poster.icon, size: 52, color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            poster.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              shadows: [Shadow(blurRadius: 6)],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      poster.title,
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 16, color: poster.color),
                        const SizedBox(width: 6),
                        Text(
                          poster.date,
                          style: TextStyle(
                            color: poster.color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: FilledButton.styleFrom(
                          backgroundColor: poster.color,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Tutup'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Header
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF6C63FF),
                const Color(0xFFFF6B35),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Galeri & Denah Venue',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            '${_posters.length} poster event',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.collections_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(
                      icon: Icon(Icons.photo_library_rounded),
                      text: 'Galeri Poster',
                    ),
                    Tab(
                      icon: Icon(Icons.map_rounded),
                      text: 'Denah Venue',
                    ),
                  ],
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // Gallery tab
              GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 260,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.67,
                ),
                itemCount: _posters.length,
                itemBuilder: (ctx, i) {
                  final poster = _posters[i];
                  return GestureDetector(
                    onTap: () => _showPosterDetail(context, poster),
                    child: _PosterCard(poster: poster, index: i),
                  );
                },
              ),

              // Venue map tab
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  children: [
                    const VenueMapViewer(),
                    const SizedBox(height: 16),
                    // Event locations list
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lokasi Event',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...sampleEvents.take(4).map((e) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.15),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C63FF)
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.location_on_rounded,
                                    color: Color(0xFF6C63FF),
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.location,
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        e.title,
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.6),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PosterItem {
  final String title;
  final Color color;
  final IconData icon;
  final String date;
  final String imagePath;
  _PosterItem(this.title, this.color, this.icon, this.date, this.imagePath);
}

// ── Poster Card Widget ──────────────────────────────────────────────────────

class _PosterCard extends StatelessWidget {
  final _PosterItem poster;
  final int index;
  const _PosterCard({required this.poster, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: poster.color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CustomPaint(
          painter: _PosterPainter(poster: poster, index: index),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Bottom gradient overlay
              Positioned(
                left: 0, right: 0, bottom: 0,
                height: 100,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              // Title at bottom
              Positioned(
                left: 0, right: 0, bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poster.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          shadows: [Shadow(blurRadius: 4)],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_rounded,
                              size: 10, color: Colors.white70),
                          const SizedBox(width: 4),
                          Text(
                            poster.date,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // Expand icon top-right
              Positioned(
                top: 8, right: 8,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.open_in_full_rounded,
                      color: Colors.white, size: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Poster CustomPainter ────────────────────────────────────────────────────

class _PosterPainter extends CustomPainter {
  final _PosterItem poster;
  final int index;
  _PosterPainter({required this.poster, required this.index});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final rng = math.Random(index * 31 + 7);
    final color = poster.color;

    // 1. Background gradient
    final gradPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color,
          Color.lerp(color, Colors.black, 0.45)!,
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), gradPaint);

    // 2. Diagonal accent stripe
    final stripePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.07)
      ..style = PaintingStyle.fill;
    final stripePath = Path()
      ..moveTo(w * 0.3, 0)
      ..lineTo(w * 0.75, 0)
      ..lineTo(w * 0.45, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(stripePath, stripePaint);

    // 3. Hex grid pattern (top 60%)
    final hexPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    const hexSize = 22.0;
    for (int row = -1; row < (h * 0.6 / (hexSize * 1.5)).ceil() + 1; row++) {
      for (int col = -1; col < (w / (hexSize * 1.73)).ceil() + 1; col++) {
        final cx = col * hexSize * 1.73 + (row.isOdd ? hexSize * 0.87 : 0);
        final cy = row * hexSize * 1.5;
        final path = Path();
        for (int k = 0; k < 6; k++) {
          final angle = math.pi / 180 * (60 * k - 30);
          final px = cx + hexSize * math.cos(angle);
          final py = cy + hexSize * math.sin(angle);
          k == 0 ? path.moveTo(px, py) : path.lineTo(px, py);
        }
        path.close();
        canvas.drawPath(path, hexPaint);
      }
    }

    // 4. Glowing circles
    for (final spec in [
      [w * 0.75, h * 0.25, 55.0, 0.18],
      [w * 0.15, h * 0.40, 35.0, 0.14],
      [w * 0.85, h * 0.55, 25.0, 0.12],
    ]) {
      for (int layer = 5; layer > 0; layer--) {
        final glowPaint = Paint()
          ..color = Colors.white.withValues(alpha: spec[3] * layer / 5 * 0.6)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(
          Offset(spec[0], spec[1]),
          spec[2] + (5 - layer) * 8,
          glowPaint,
        );
      }
      final circlePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.18)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      canvas.drawCircle(Offset(spec[0], spec[1]), spec[2], circlePaint);
    }

    // 5. Circuit-style lines with nodes
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final nodePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35);
    for (int i = 0; i < 8; i++) {
      final startX = rng.nextDouble() * w;
      final startY = rng.nextDouble() * h * 0.65;
      var x = startX;
      var y = startY;
      for (int seg = 0; seg < 3; seg++) {
        final isH = rng.nextBool();
        final len = 20.0 + rng.nextDouble() * 50;
        final dir = rng.nextBool() ? 1.0 : -1.0;
        final nx = isH ? x + dir * len : x;
        final ny = isH ? y : y + dir * len;
        canvas.drawLine(Offset(x, y), Offset(nx, ny), linePaint);
        canvas.drawCircle(Offset(nx, ny), 2.5, nodePaint);
        x = nx;
        y = ny;
      }
    }

    // 6. Dot grid (upper area)
    final dotPaint = Paint()..color = Colors.white.withValues(alpha: 0.20);
    for (double dx = 12; dx < w; dx += 22) {
      for (double dy = 12; dy < h * 0.5; dy += 22) {
        canvas.drawCircle(Offset(dx, dy), 1.5, dotPaint);
      }
    }

    // 7. Sparkle stars
    final starPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.65)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    final starSeeds = [
      [w * 0.2, h * 0.15], [w * 0.6, h * 0.08], [w * 0.9, h * 0.22],
      [w * 0.4, h * 0.35], [w * 0.1, h * 0.45], [w * 0.8, h * 0.38],
      [w * 0.5, h * 0.18], [w * 0.3, h * 0.28],
    ];
    for (final s in starSeeds) {
      final cx = s[0]; final cy = s[1];
      const r = 4.5;
      for (int k = 0; k < 4; k++) {
        final angle = math.pi / 4 * k;
        canvas.drawLine(
          Offset(cx - r * math.cos(angle), cy - r * math.sin(angle)),
          Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
          starPaint,
        );
      }
      canvas.drawCircle(Offset(cx, cy), 1.5,
          Paint()..color = Colors.white.withValues(alpha: 0.9));
    }

    // 8. Category badge area (top-left)
    final badgePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.20)
      ..style = PaintingStyle.fill;
    final badgeRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(8, 8, 50, 22),
      const Radius.circular(11),
    );
    canvas.drawRRect(badgeRect, badgePaint);

    // 9. Center large icon visual (circle with icon-like shape)
    final iconBgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    final iconBorderPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(Offset(w / 2, h * 0.38), 32, iconBgPaint);
    canvas.drawCircle(Offset(w / 2, h * 0.38), 32, iconBorderPaint);
    canvas.drawCircle(Offset(w / 2, h * 0.38), 22,
        Paint()..color = Colors.white.withValues(alpha: 0.20));

    // 10. Wave lines
    final wavePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (final baseY in [h * 0.55, h * 0.60]) {
      final wavePath = Path();
      wavePath.moveTo(0, baseY);
      for (double x = 0; x <= w; x += 2) {
        final y = baseY + 8 * math.sin(x * 0.04 + index * 0.8);
        wavePath.lineTo(x, y);
      }
      canvas.drawPath(wavePath, wavePaint);
    }
  }

  @override
  bool shouldRepaint(_PosterPainter old) => old.index != index;
}

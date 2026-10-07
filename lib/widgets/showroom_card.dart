import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'car_illustration.dart';

class _Paint {
  const _Paint(this.name, this.color);

  final String name;
  final Color color;
}

const _paints = [
  _Paint('Graphite', Color(0xFF2E2F35)),
  _Paint('Silver', Color(0xFF8E9197)),
  _Paint('Crimson', Color(0xFF8A2A2D)),
  _Paint('Midnight', Color(0xFF263552)),
];

class ShowroomCard extends StatefulWidget {
  const ShowroomCard({super.key});

  @override
  State<ShowroomCard> createState() => _ShowroomCardState();
}

class _ShowroomCardState extends State<ShowroomCard> {
  var _selected = 1;

  @override
  Widget build(BuildContext context) {
    final paint = _paints[_selected];
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.sheet),
      child: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2B30), AppColors.charcoalDeep],
          ),
        ),
        child: Stack(
          children: [
            const Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment(0, -0.2),
                    radius: 0.9,
                    colors: [Color(0x24FFFFFF), Color(0x00FFFFFF)],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(paint),
                  Expanded(child: _buildStage(paint.color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(_Paint paint) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Coupe GT',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 8),
                  _PulseDot(),
                ],
              ),
              const SizedBox(height: 1),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: Text(
                  '${paint.name} · 320 hp · Hybrid',
                  key: ValueKey(paint.name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Row(
            children: [
              for (var i = 0; i < _paints.length; i++)
                _Swatch(
                  paint: _paints[i],
                  selected: i == _selected,
                  onTap: () => setState(() => _selected = i),
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// Car on a glossy floor: giant model text behind, mirrored reflection below.
  Widget _buildStage(Color bodyColor) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The stage (car + reflection) is 0.96 car-heights tall; scale the car
        // to whichever of the card's width or remaining height is tighter.
        final carHeight = [
          constraints.maxWidth.clamp(0.0, 330.0) * 0.41,
          constraints.maxHeight / 0.96,
        ].reduce((a, b) => a < b ? a : b);
        final carWidth = carHeight / 0.41;
        // Bottom of the tyres in the car painter's coordinates.
        final tyreBottom = carHeight * 0.83;
        final reflectionTop = tyreBottom - (carHeight - tyreBottom);
        final reflectionHeight = carHeight * 0.3;

        return TweenAnimationBuilder<Color?>(
          tween: ColorTween(end: bodyColor),
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeOutCubic,
          builder: (context, color, _) {
            final car = CarIllustration(
              width: carWidth,
              height: carHeight,
              bodyColor: color,
            );
            return Center(
              child: SizedBox(
                height: reflectionTop + reflectionHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: -carHeight * 0.12,
                      child: Text(
                        'GT',
                        style: TextStyle(
                          fontSize: carHeight * 1.15,
                          height: 1,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -6,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    Positioned(
                      top: tyreBottom - 14,
                      width: carWidth,
                      height: 28,
                      child: const CustomPaint(painter: _FloorGlowPainter()),
                    ),
                    Positioned(
                      top: reflectionTop,
                      width: carWidth,
                      height: reflectionHeight,
                      child: ClipRect(
                        child: ShaderMask(
                          blendMode: BlendMode.dstIn,
                          shaderCallback: (bounds) => const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x5CFFFFFF), Color(0x00FFFFFF)],
                          ).createShader(bounds),
                          child: OverflowBox(
                            alignment: Alignment.topCenter,
                            maxHeight: carHeight,
                            child: Transform.flip(flipY: true, child: car),
                          ),
                        ),
                      ),
                    ),
                    car,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.paint,
    required this.selected,
    required this.onTap,
  });

  final _Paint paint;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: '${paint.name} paint',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.0),
                width: 1.5,
              ),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.lerp(paint.color, Colors.white, 0.3)!,
                    paint.color,
                  ],
                ),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot();

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFF4CD787),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Soft pool of light on the showroom floor under the car.
class _FloorGlowPainter extends CustomPainter {
  const _FloorGlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Offset.zero & size,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );
  }

  @override
  bool shouldRepaint(_FloorGlowPainter oldDelegate) => false;
}

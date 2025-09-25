import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/core/utils/app_colors.dart';

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 0; i < 4; i++) {
      final path = Path();
      path.moveTo(0, 1 + i * 50);
      path.quadraticBezierTo(
        size.width * 0.6, 0 + i * 5,
        size.width, 150.0 + i * 40,
      );
      canvas.drawPath(path, paint);
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  final List<String> _textLines = ["Define", "yourself in", "your unique", "way."];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(begin: 3.14159, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildAnimatedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _textLines.asMap().entries.map((lineEntry) {
        final lineIndex = lineEntry.key;
        final line = lineEntry.value;
        
        return Row(
          children: line.split('').asMap().entries.map((charEntry) {
            final charIndex = charEntry.key;
            final char = charEntry.value;
            
            final startOffset = Offset(
              (charIndex % 2 == 0 ? -1 : 1) * (100.0 + charIndex * 20),
              (-80 + (lineIndex + charIndex) % 3 * 30).toDouble(),
            );
            
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final dx = startOffset.dx * (1 - _controller.value);
                final dy = startOffset.dy * (1 - _controller.value);
                
                return Transform.translate(
                  offset: Offset(dx, dy),
                  child: Text(
                    char == ' ' ? '\u00A0' : char, 
                    style: TextStyle(
                      color: AppColors.containerBlack,
                      fontSize: 64,
                      fontWeight: FontWeight.w600,
                      height: 0.8,
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Custom paint (orqa fon chiziqlar)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 300),
                    child: CustomPaint(
                      size: const Size(double.infinity, 270),
                      painter: SplashPainter(),
                    ),
                  ),
                ),
                // Harflar animatsiyasi
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 20),
                  child: _buildAnimatedText(),
                ),
                // Rasm animatsiyasi (teskari aylanishdan normalga)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 65, left: 10),
                      child: Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: Image.asset("assets/male.png"),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: GestureDetector(
          onTap: () => GoRouter.of(context).push("/register"),
          child: Container(
            width: 341,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.containerBlack,
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Get Started", style: TextStyle(color: AppColors.white)),
                  const SizedBox(width: 10),
                  Image.asset("assets/arrow_right.png", width: 14, height: 14),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
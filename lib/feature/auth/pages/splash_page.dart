import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
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

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotationAnimation;
  late final Animation<Alignment> _alignmentAnimation;

  @override
  void initState() {
    super.initState();

    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * 3.14159)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _alignmentAnimation = AlignmentTween(
      begin: Alignment(0, -1.5),
      end: Alignment.center,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    await Future.delayed(const Duration(seconds: 4));
    if (!mounted) return;
    context.go('/onboarding');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
       body: Stack(
  children: [
    Padding(
      padding: const EdgeInsets.only(top: 100),
      child: CustomPaint(
        size: Size(double.infinity, 270),
        painter: SplashPainter(),
      ),
    ),
    AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Align(
          alignment: _alignmentAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: child,
          ),
        );
      },
      child: Image.asset("assets/splash_logo.png", width: 150),
    ),
  ],
),

    );
  }
}

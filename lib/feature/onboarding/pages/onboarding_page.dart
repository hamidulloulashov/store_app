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
class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: CustomPaint(
                    size: const Size(double.infinity, 270),
                    painter: SplashPainter(),
                  ),
                ),
              ),
              Padding(
          padding: const EdgeInsets.only(left: 12, top: 50, bottom: 50),
          child: Text(
            "Define\nyourself in\nyour unique\nway.",
            style: TextStyle(
        color: AppColors.containerBlack,
        fontSize: 64,
        fontWeight: FontWeight.w600,
        height: 0.8, 
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 65, left: 10),
          child: Image.asset("assets/male.png"),
        )
          ]
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10, left: 20, right: 20),
        child: GestureDetector(
          onTap: () => GoRouter.of(context).push("/register"),
          child: Container(
            width: 341,
            height: 54,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.containerBlack),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Get Started",style: TextStyle(color: AppColors.white),),
                  SizedBox(width: 10,),
             Image.asset("assets/arrow_right.png", width: 14,height: 14,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


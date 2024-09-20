import 'package:flutter/material.dart';
import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const CurvedHeader(),
        TAppBar(
          title: Container(),
        ),
      ],
    );
  }
}

class CurvedHeader extends StatefulWidget {
  const CurvedHeader({super.key});

  @override
  _CurvedHeaderState createState() => _CurvedHeaderState();
}

class _CurvedHeaderState extends State<CurvedHeader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _curveOpacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _curveOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350.0,
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _curveOpacityAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _curveOpacityAnimation.value,
                child: CustomPaint(
                  painter: _CurvePainter(),
                  child: Container(),
                ),
              );
            },
          ),
          Positioned(
            top: 75,
            left: 0,
            right: 0,
            child: SingleChildScrollView( // ScrollView para evitar desbordamiento
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ajusta el tamaño de la columna
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        TTexts.homeAppbarTitleWave,
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        TTexts.homeAppbarSubtitleMotivational,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = TColors.primary
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.4); // Ajusta la altura del inicio de la curva
    path.quadraticBezierTo(size.width * 0.5, size.height * 1.0, size.width, size.height * 0.4);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

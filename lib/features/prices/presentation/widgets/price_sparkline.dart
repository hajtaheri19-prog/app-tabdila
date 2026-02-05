import 'package:flutter/material.dart';

class PriceSparkline extends StatelessWidget {
  final List<double> data;
  final Color color;
  final double width;
  final double height;

  const PriceSparkline({
    super.key,
    required this.data,
    required this.color,
    this.width = 80,
    this.height = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: SparklinePainter(data, color),
      ),
    );
  }
}

class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  SparklinePainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final double stepX = size.width / (data.length - 1);

    // Find min and max for normalization
    double min = data[0];
    double max = data[0];
    for (var val in data) {
      if (val < min) min = val;
      if (val > max) max = val;
    }

    double range = max - min;
    if (range == 0) range = 1;

    for (int i = 0; i < data.length; i++) {
      double x = i * stepX;
      // Normalize y: 0 at top (max value), height at bottom (min value)
      double y = size.height - ((data[i] - min) / range * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

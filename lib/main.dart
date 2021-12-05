import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller = AnimationController(
      duration: const Duration(milliseconds: 600), vsync: this)
    ..forward();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomPaint(
              painter: MyPainter(percentage: 53.0, controller: controller),
              size: const Size(300.0, 300.0),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double percentage;
  final AnimationController controller;

  MyPainter({required this.percentage, required this.controller})
      : super(repaint: controller);

  late double effectiveRadius;

  Radius get _circularRadius => Radius.circular(effectiveRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final double _width = size.width;
    final double _height = size.height;
    Offset center = Offset(size.width / 2, size.height / 2); //  坐标中心
    effectiveRadius = math.min(size.width / 2, size.height / 2);

    double percentage = this.percentage > (100 - 14) ? 83.0 : this.percentage;
    double percentageOther = 100 - percentage - 14;

    double arcAngle = 2 * math.pi * (percentage / 100);
    double arcAngleOther = 2 * math.pi * (percentageOther / 100);

    double a = 2 * math.pi * ((percentage + 7) / 100);

    print('size: $size');
    print('circularRadius: $_circularRadius');

    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26.0
      ..strokeCap = StrokeCap.round;

    Paint paint2 = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22.0
      ..strokeCap = StrokeCap.round;

    Path path = Path()
      ..moveTo(_width / 2, 0)
      ..addArc(Rect.fromCircle(center: center, radius: effectiveRadius / 2),
          math.pi * 2, arcAngle);
    Path path2 = Path()
      ..addArc(Rect.fromCircle(center: center, radius: effectiveRadius / 2), a,
          arcAngleOther);
    print('aaaaa: ${path.computeMetrics().single}');
    print('aaaaa: ${controller.value}');
    PathMetric metric = path.computeMetrics().single;
    PathMetric metric2 = path2.computeMetrics().single;
    canvas.drawPath(
        metric.extractPath(0, metric.length * controller.value), paint);
    canvas.drawPath(
        metric2.extractPath(0, metric2.length * controller.value), paint2);
  }

  @override
  bool shouldRepaint(covariant MyPainter oldDelegate) {
    return true;
  }
}

import 'package:flutter/material.dart';

/// scaffold
class SignatureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Signature(),
    );
  }
}

/// painter
class SignaturePainter extends CustomPainter {
  SignaturePainter({this.points});

  final List<Offset> points;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      Offset p1 = points[i];
      Offset p2 = points[i + 1];
      if (p1 != null && p2 != null) {
        canvas.drawLine(p1, p2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldPainter) => oldPainter.points != points;
}

/// statefull widget
class Signature extends StatefulWidget {
  createState() => _SignatureState();
}

/// state
class _SignatureState extends State<Signature> {
  var _points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject();
        Offset p = referenceBox.globalToLocal(details.globalPosition);
        setState(() {
          _points = List.from(_points)..add(p);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      onPanCancel: () => _points.add(null),
      child: CustomPaint(painter: SignaturePainter(points: _points), size: Size.infinite),
    );
  }
}
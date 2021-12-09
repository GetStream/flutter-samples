import 'package:flutter/cupertino.dart';

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment? alignment;
  final bool hasTail;

  ChatBubble({
    required this.color,
    required this.hasTail,
    this.alignment,
  }) : paintFill = Paint()
          ..color = color
          ..style = PaintingStyle.fill;

  final Paint paintFill;

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    const cornerSize = 18.0;
    const buffer = 6.0;
    const innerTailWidth = 7.0;
    const innerTailHeight = 4.0;
    if (alignment == Alignment.topRight) {
      path.moveTo(0, cornerSize);
      path.lineTo(0, size.height - cornerSize);
      path.arcToPoint(Offset(cornerSize, size.height),
          radius: const Radius.circular(cornerSize), clockwise: false);

      if (hasTail) {
        path.lineTo(size.width - cornerSize - innerTailWidth, size.height);
        path.arcToPoint(
            Offset(size.width - buffer - innerTailWidth,
                size.height - innerTailHeight),
            radius: const Radius.circular(cornerSize),
            clockwise: false);

        path.arcToPoint(Offset(size.width, size.height),
            radius: const Radius.circular(buffer * 2), clockwise: false);

        path.arcToPoint(
            Offset(size.width - buffer, size.height - buffer - innerTailHeight),
            radius: const Radius.circular(buffer + innerTailHeight),
            clockwise: true);
      } else {
        path.lineTo(size.width - cornerSize, size.height);
        path.arcToPoint(Offset(size.width - buffer, size.height - cornerSize),
            radius: const Radius.circular(cornerSize), clockwise: false);
      }

      path.lineTo(size.width - buffer, cornerSize);

      path.arcToPoint(Offset(size.width - cornerSize - buffer, 0),
          radius: const Radius.circular(cornerSize), clockwise: false);

      path.lineTo(cornerSize, 0);

      path.arcToPoint(const Offset(0, cornerSize),
          radius: const Radius.circular(cornerSize), clockwise: false);
    } else {
      path.moveTo(size.width, cornerSize);
      path.arcToPoint(Offset(size.width - cornerSize, 0),
          radius: const Radius.circular(cornerSize), clockwise: false);

      path.lineTo(cornerSize + buffer, 0);

      path.arcToPoint(const Offset(buffer, cornerSize),
          radius: const Radius.circular(cornerSize), clockwise: false);

      if (hasTail) {
        path.lineTo(buffer, size.height - buffer - innerTailHeight);

        path.arcToPoint(Offset(0, size.height),
            radius: const Radius.circular(buffer + innerTailHeight),
            clockwise: true);

        path.arcToPoint(
            Offset(buffer + innerTailWidth, size.height - innerTailHeight),
            radius: const Radius.circular(buffer * 2),
            clockwise: false);

        path.arcToPoint(Offset(cornerSize + innerTailWidth, size.height),
            radius: const Radius.circular(cornerSize), clockwise: false);
      } else {
        path.lineTo(buffer, size.height - cornerSize);
        path.arcToPoint(Offset(buffer + cornerSize, size.height),
            radius: const Radius.circular(cornerSize), clockwise: false);
      }

      path.lineTo(size.width - cornerSize, size.height);
      path.arcToPoint(Offset(size.width, size.height - cornerSize),
          radius: const Radius.circular(cornerSize), clockwise: false);
    }
    canvas.drawPath(
      path,
      paintFill,
    );
  }

  @override
  bool shouldRepaint(ChatBubble oldDelegate) {
    if (color != oldDelegate.color ||
        alignment != oldDelegate.alignment ||
        hasTail != oldDelegate.hasTail) {
      return true;
    } else {
      return false;
    }
  }
}

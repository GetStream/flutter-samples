import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('iMessage'),
          ),
          body: IMessage()),
    );
  }
}

class IMessage extends StatelessWidget {
  const IMessage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LeftColumn(),
          RightColumn(),
        ],
      ),
    );
  }
}

class RightColumn extends StatelessWidget {
  const RightColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.4,
      child: Container(
        color: Color(0xFFFFFFFF),
        child: Column(
          children: [
            InfoHeader(phoneNumber: '937-340-7510'),
            Column(
              children: [
                ChatMessageHeader(),
                ChatMessage(
                    alignment: Alignment.centerLeft, message: 'Hello World'),
              ],
            )
            // Center(
            //   child: Text("Right column"),
            // )
          ],
        ),
      ),
    );
  }
}

class ChatMessageHeader extends StatelessWidget {
  const ChatMessageHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('iMessage'), Text('mer. 20 janv. à 15:31')],
    );
  }
}

class ChatMessage extends StatelessWidget {
  final Alignment alignment;
  final String message;

  const ChatMessage({Key key, @required this.alignment, @required this.message})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment:
            alignment, //Change this to Alignment.topRight or Alignment.topLeft
        child: CustomPaint(
          painter: ChatBubble(color: Color(0xFFE9E9EB), alignment: alignment),
          child: Container(
            margin: EdgeInsets.all(10),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(message),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends CustomPainter {
  final Color color;
  final Alignment alignment;

  ChatBubble({
    @required this.color,
    this.alignment,
  });

  final _radius = 10.0;
  final _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0,
            size.width - 8,
            size.height,
            bottomLeft: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(size.width - _x, size.height - 20);
      path.lineTo(size.width - _x, size.height);
      path.lineTo(size.width, size.height);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x,
            0.0,
            size.width,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            0,
            size.width,
            size.height,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(0, size.height);
      path.lineTo(_x, size.height);
      path.lineTo(_x, size.height - 20);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x,
            size.height,
            topRight: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class InfoHeader extends StatelessWidget {
  final String phoneNumber;
  const InfoHeader({
    Key key,
    this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFAFCFC),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('To: $phoneNumber'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.info),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LeftColumn extends StatelessWidget {
  const LeftColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        color: Color(0xFFD3D6DA),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.create),
              ),
            ),
            Search(),
            MessagePreview()
          ],
        ),
      ),
    );
  }
}

class MessagePreview extends StatelessWidget {
  const MessagePreview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Color(0xFF3478F6),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(),
          leading: CircleAvatar(),
          title: Text(
            '937-340-7510',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          trailing: Text(
            '31/01/2021',
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          ),
          subtitle: Text(
            'Happy birthday',
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

class Search extends StatelessWidget {
  const Search({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        color: Color(0xFFC8CDD0),
        child: TextField(
          decoration: InputDecoration(
            hintStyle: TextStyle(color: Color(0xFF8E8E93)),
            // hoverColor: Colors.red, //Color(0xFFC8CDD0),
            prefixIcon: Icon(Icons.search, color: Color(0xFF646567)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF8BAEEE), width: 5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFC1C5C9), width: 1.0),
            ),
            hintText: 'Search',
          ),
        ),
      ),
    );
  }
}

class Message {
  final String phoneNumber;

  Message(this.phoneNumber);
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

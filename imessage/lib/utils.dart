import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
String formatDate(DateTime date) {
    final dateFormat = DateFormat.yMd().add_jm(); //mer. 20 janv. à 15:31
    return dateFormat.format(date);
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

class CupertinoListTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  const CupertinoListTile(
      {Key key,
      this.leading,
      this.title,
      this.subtitle,
      this.trailing,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                leading,
                SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    title,
                    subtitle,
                  ],
                ),
              ],
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}



class CupertinoCircleAvatar extends StatelessWidget {
  final String url;
  final double size;
  const CupertinoCircleAvatar({Key key, this.url, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size / 2),
      child: Image.network(
        url,
        height: size,
        width: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
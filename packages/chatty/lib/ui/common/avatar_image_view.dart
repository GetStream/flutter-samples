import 'package:flutter/material.dart';

class AvatarImageView extends StatelessWidget {
  const AvatarImageView({Key key, this.onTap, this.child}) : super(key: key);
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipOval(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[100],
              ),
              height: 180,
              width: 180,
              child: child,
            ),
          ),
          Positioned(
            bottom: -15,
            right: 0,
            child: GestureDetector(
              onTap: onTap,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30,
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

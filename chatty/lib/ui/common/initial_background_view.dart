import 'package:flutter/material.dart';

class InitialBackgroundView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          right: -75,
          child: Image.asset(
            'assets/icon-top-right.png',
            height: 150,
          ),
        ),
        Positioned(
          bottom: -50,
          right: -50,
          child: Image.asset(
            'assets/icon-bottom-right.png',
            height: 200,
          ),
        ),
      ],
    );
  }
}

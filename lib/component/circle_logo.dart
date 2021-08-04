import 'package:flutter/material.dart';

class CircleLogo extends StatelessWidget {
  final double size;
  final String image;
  const CircleLogo({
    Key? key, 
    required this.image, 
    this.size = 120
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.size,
      width: this.size,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        shape: BoxShape.circle,
        image: DecorationImage(image: NetworkImage(this.image), fit: BoxFit.fill),
      ),
    );
  }
}

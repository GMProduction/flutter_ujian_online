import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final double height;
  const CustomCard({
    Key? key, 
    required this.child,
    this.color = Colors.white, 
    this.height = 0
    })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: this.height,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12.withOpacity(0.1), width: 1),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(2, 2))
        ],
      ),
      child: this.child,
    );
  }
}

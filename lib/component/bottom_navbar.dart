import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int selected;

  const BottomNavbar({Key? key, this.selected = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 70,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, -2))
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              String current = ModalRoute.of(context)!.settings.name!;
              if (current != "/dashboard") {
                Navigator.pushNamed(context, "/dashboard");
              }
            },
            child: Icon(
              Icons.home,
              size: 26,
              color: this.selected == 0 ? Colors.lightBlue : Colors.grey,
            ),
          ),
          GestureDetector(
            onTap: () {
              String current = ModalRoute.of(context)!.settings.name!;
              if (current != "/history") {
                Navigator.pushNamed(context, "/history");
              }
            },
            child: Icon(
              Icons.history,
              size: 26,
              color: this.selected == 1 ? Colors.lightBlue : Colors.grey,
            ),
          ),
          Icon(
            Icons.person,
            size: 26,
            color: this.selected == 2 ? Colors.lightBlue : Colors.grey,
          ),
        ],
      ),
    );
  }
}

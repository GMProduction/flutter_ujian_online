import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", ModalRoute.withName("/login"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("logout"),
          onPressed: () {
            logout();
          },
        ),
      ),
    );
  }
}

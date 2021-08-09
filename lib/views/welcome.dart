import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/component/circle_logo.dart';
import 'package:ujian_online/helper/helper.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSplash();
  }

  void initSplash() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString("token");
    if (token != null) {
      Navigator.popAndPushNamed(context, "/dashboard");
    } else {
      Navigator.popAndPushNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          child: CircleLogo(image: BaseAvatar),
        ),
      ),
    );
  }
}

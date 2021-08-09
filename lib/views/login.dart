import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/component/circle_logo.dart';
import 'package:ujian_online/helper/helper.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = '';
  String password = '';
  bool isLoading = false;

  void login() async {
    try {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> params = {"username": username, "password": "siswa"};
      var formData = FormData.fromMap(params);
      final response = await Dio().post(
        '$HostAddress/login',
        options: Options(
          headers: {"Accept": "application/json"},
        ),
        data: formData,
      );
      final int code = response.data['status'] as int;
      print(response.data);
      if (code == 200) {
        final String token = response.data['msg'] as String;
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("token", token);
        Fluttertoast.showToast(
            msg: "Login Berhasil Token $token",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamedAndRemoveUntil(
            context, "/dashboard", ModalRoute.withName("/dashboard"));
      } else {
        Fluttertoast.showToast(
            msg: "Login Gagal Silahkan Cek Username Dan Password...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Terjadi Kesalahan Pada Server...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleLogo(image: BaseAvatar)),
          ),
          Text(
            "Selamat Datang Di Sistem Informasi Ujian Online",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  username = text;
                });
              },
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: Icon(Icons.account_circle),
                  hintText: "Username"),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: TextField(
              onChanged: (text) {
                setState(() {
                  password = text;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  prefixIcon: Icon(Icons.lock),
                  hintText: "Password"),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () {
                if (!isLoading) {
                  login();
                }
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue,
                ),
                child: Center(
                  child: isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "loading...",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

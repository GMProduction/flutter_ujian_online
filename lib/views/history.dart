import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/component/bottom_navbar.dart';
import 'package:ujian_online/component/history_card.dart';
import 'package:ujian_online/helper/helper.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<dynamic> _listHistory = [];
  @override
  void initState() {
    super.initState();
    getHistory();
  }

  void getHistory() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      print(token);
      final response = await Dio().get(
        '$HostAddress/paket',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      print(response.data);
      setState(() {
        _listHistory = response.data as List;
      });
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
    // setState(() {
    //   isLoading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Paket yang sudah di kerjakan",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: _listHistory.map((history) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/nilai",
                                    arguments: history);
                              },
                              child: HistoryCard(
                                // mapel: history["mapel"],
                                paket: history["mapel"],
                                nilai: history["nilai"] as int,
                                image:
                                    "$HostImage${history["url_gambar"].toString()}",
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            BottomNavbar(
              selected: 1,
            )
          ],
        ),
      ),
    );
  }
}

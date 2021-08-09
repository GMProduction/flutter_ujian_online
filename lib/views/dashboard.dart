import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/component/bottom_navbar.dart';
import 'package:ujian_online/component/ongoing_card.dart';
import 'package:ujian_online/component/profile_navbar.dart';
import 'package:ujian_online/helper/helper.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> _ongoingList = [];
  List<dynamic> _upComingList = [];
  bool isLoadingOngoing = true;
  bool isLoadingUpComming = true;

  @override
  void initState() {
    super.initState();
    getOngoingTest();
    getUpComingTest();
  }

  //mengambil data ujian yang sedang berlangsung
  void getOngoingTest() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      final response = await Dio().get(
        '$HostAddress/paket-ongoing',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      print(response.data);
      setState(() {
        _ongoingList = response.data["payload"] as List;
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
    setState(() {
      isLoadingOngoing = false;
    });
  }

  void getUpComingTest() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      final response = await Dio().get(
        '$HostAddress/paket-coming-soon',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      print(response.data);
      setState(() {
        _upComingList = response.data["payload"] as List;
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
    setState(() {
      isLoadingUpComming = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            ProfileNavbar(
              nama: "Bagus Yanuar",
              kelas: "XI IPS 2",
            ),
            Expanded(
                child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Ujian Yang Sedang Berlangsung",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: _ongoingList.map((ujian) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/detail",
                                    arguments: ujian);
                              },
                              child: ListCard(
                                paket: ujian["nama_paket"].toString(),
                                mapel: ujian["mapel"].toString(),
                                image:
                                    "$HostImage${ujian["url_gambar"].toString()}",
                                isOngoing: true,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Ujian Yang Akan Datang",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Column(
                      children: _upComingList.map((ujian) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 5),
                          child: ListCard(
                            paket: ujian["nama_paket"].toString(),
                            mapel: ujian["mapel"].toString(),
                            time: ujian["waktu_pengerjaan"],
                            image:
                                "$HostImage${ujian["url_gambar"].toString()}",
                            isOngoing: false,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            )),
            BottomNavbar()
          ],
        ),
      ),
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/helper/helper.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

bool isLoading = true;
List<dynamic> _listSoal = [];
Map<String, dynamic> ujian = {};

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      if (arguments != null) {
        Map<String, dynamic> tempArgs = arguments as Map<String, dynamic>;
        setState(() {
          ujian = tempArgs;
        });
        int id = tempArgs["id"] as int;
        getDetailPaket(id);
      }
      print(arguments);
    });
  }

//cek-peserta/idPaket
//cek-peserta/idPaket/selesai
  void getDetailPaket(int id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      print(token);
      final response = await Dio().get(
        '$HostAddress/paket/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      print(response.data);
      setState(() {
        _listSoal = response.data["payload"]["get_soal_id"] as List;
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
      isLoading = false;
    });
  }

  void setSelesai(String token, int id) async {
    try {
      final response = await Dio().get(
        '$HostAddress/cek-peserta/$id/selesai',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      print(response.data);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menyelesaikan Ujian",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
  }

  void mulaiTest(int id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      print(token);
      final response = await Dio().get(
        '$HostAddress/cek-peserta/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );

      print(response.data);
      //skip to history if waktu_selesai not null

      DateTime start = DateTime.parse(response.data["waktu_mulai"].toString());
      DateTime testFinish = start.add(const Duration(minutes: 90));
      DateTime now = DateTime.now();
      if (testFinish.compareTo(now) <= 0) {
        //Waktu Terlewat kirim api selesai
        setSelesai(token, id);
        Navigator.popAndPushNamed(context, "/history");
      } else {
        //Waktu masih sisa kirim
        int sisaWaktu = testFinish.difference(now).inMinutes;
        print("Sisa waktu : $sisaWaktu");
        Fluttertoast.showToast(
            msg: "Waktu Masih Bisa...",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.pushNamed(context, "/soal", arguments: {
          "soal": _listSoal,
          "sisa": sisaWaktu,
        });
      }

      //
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 20),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: (ujian["url_gambar"] == null ||
                                        ujian["url_gambar"] == "")
                                    ? NetworkImage(BaseAvatar)
                                    : NetworkImage(
                                        "$HostImage${ujian["url_gambar"].toString()}"),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ujian["mapel"].toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              // Text(
                              //   ujian["mapel"].toString(),
                              //   style: TextStyle(fontSize: 14),
                              // ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.access_alarm,
                                    size: 12,
                                  )),
                              Text(
                                "${ujian["waktu_pengerjaan"].toString()} (Menit)",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Text("Peraturan",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold))),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Html(
                          data: ujian["pengaturan"] != null
                              ? ujian["pengaturan"].toString()
                              : "<p></p>"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
              child: GestureDetector(
                onTap: () {
                  int id = ujian["id"] as int;
                  mulaiTest(id);
                  // Navigator.pushNamed(context, "/soal",
                  //     arguments: {"soal": _listSoal, "paket_id": ujian["id"]});
                },
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.lightBlue),
                  child: Center(
                    child: Text(
                      "Mulai Mengerjakan",
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
      ),
    );
  }
}

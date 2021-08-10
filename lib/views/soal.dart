import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/helper/helper.dart';

class Soal extends StatefulWidget {
  @override
  _SoalState createState() => _SoalState();
}

class _SoalState extends State<Soal> {
  dynamic soal;
  List<dynamic> pilihan = [];
  List<dynamic> listSoal = [];
  int selected = 0;
  bool isLoading = true;
  int sisaWaktu = 0;
  int selectedAnswer = 0;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    hitungWaktu();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      print(arguments);
      if (arguments != null) {
        List<dynamic> tempArgs = arguments["soal"] as List;
        int sisa = arguments["sisa"] as int;
        setState(() {
          listSoal = tempArgs;
          sisaWaktu = sisa;
        });
        if (listSoal.length > 0) {
          setState(() {
            selected = 0;
          });
          getSoalById(listSoal[0]["id"] as int);
        }
      }
    });
  }

  void hitungWaktu() {
    // DateTime now = DateTime.now();
    // DateTime future = DateTime(2021, 08, 10, 14, 10, 00);
    // int sisa = future.difference(now).inMinutes;
    // if (sisa > 0) {
    //   setState(() {
    //     sisaWaktu = future.difference(now).inMinutes;
    //   });
    // }
    const oneSec = const Duration(minutes: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      if (sisaWaktu == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          sisaWaktu--;
        });
      }
    });
    // print(future.difference(now).inMinutes);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer != null) {
      _timer!.cancel();
      print("CANCEL TIMER");
    }
    super.dispose();
  }

  void getSoalById(int id) async {
    print("=====Jumlah Soal=====");
    print(listSoal.length);
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      print(token);
      final response = await Dio().get(
        '$HostAddress/soal/$id',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );

      print(response.data);
      setState(() {
        soal = response.data["payload"]["soal"];
        pilihan = response.data["payload"]["get_jawaban"] as List;
        selectedAnswer = response.data["payload"]["get_nilai"] == null
            ? 0
            : response.data["payload"]["get_nilai"]["id_jawaban"] as int;
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

  void jawab(int id) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = preferences.getString("token") ?? "";
      var data = FormData.fromMap({"id_jawaban": id});
      int idSoal = listSoal[selected]["id"] as int;
      final response = await Dio().post(
        '$HostAddress/soal/$idSoal',
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          },
        ),
      );
      setState(() {
        selectedAnswer = id;
      });
      print(response.data);
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
  }

  void gantiSoal(int index) {
    getSoalById(listSoal[index]["id"] as int);
  }

  @override
  Widget build(BuildContext context) {
    print(selected);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            "Sisa Waktu : ${sisaWaktu.toString()} Menit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
                      child: Text(
                        "Soal Nomor ${(selected + 1).toString()}",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Html(
                            data: soal != null
                                ? soal.toString()
                                : "<div></div>")),
                    Column(
                      children: pilihan.map((e) {
                        int index = pilihan.indexOf(e);
                        int id = e["id"] as int;
                        return Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: GestureDetector(
                            onTap: () {
                              jawab(id);
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 15, bottom: 15),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: id == selectedAnswer
                                    ? Colors.lightBlue
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.lightBlue,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${String.fromCharCode(65 + index).toLowerCase()}. ",
                                    style: TextStyle(
                                        color: id == selectedAnswer
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Expanded(
                                    child: Text(
                                      e["jawaban"].toString(),
                                      style: TextStyle(
                                          color: id == selectedAnswer
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding:
                  EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
              child: selected == 0
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          selected += 1;
                        });
                        gantiSoal(selected);
                      },
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            "Berikutnya",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selected += -1;
                              });
                              gantiSoal(selected);
                            },
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "Sebelumnya",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              if ((listSoal.length - 1) == selected) {
                                //kumpulkan
                              } else {
                                setState(() {
                                  selected += 1;
                                });
                                gantiSoal(selected);
                              }
                            },
                            child: Container(
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: ((listSoal.length - 1) == selected)
                                    ? Text(
                                        "Kumpulkan",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    : Text(
                                        "Berikutnya",
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }
}

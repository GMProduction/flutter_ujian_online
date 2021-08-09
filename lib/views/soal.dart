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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      print(arguments);
      if (arguments != null) {
        List<dynamic> tempArgs = arguments as List;
        setState(() {
          // soal = filter["soal"][0]["soal"];
          // pilihan = filter["soal"][0]["pilihan"];
          listSoal = tempArgs;
        });
        if (listSoal.length > 0) {
          setState(() {
            selected = 0;
          });
          getSoalById(listSoal[0]["id"] as int);
        }
      }

      // getSoalById(arguments as int);
      // List<Map<String, dynamic>> dummy = DataDummies.ongoingDummy;
      // Map<String, dynamic> filter =
      //     dummy.firstWhere((element) => element["id"] == arguments);

      // print(listSoal.length);
    });
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
      });
      // setState(() {
      //   _ongoingList = response.data["payload"] as List;
      // });
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

  void gantiSoal(int index) {
    getSoalById(listSoal[index]["id"] as int);
    // setState(() {
    //   soal = listSoal[index]["soal"];
    //   pilihan = listSoal[index]["pilihan"];
    // });
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
                        return Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.lightBlue, width: 1)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${String.fromCharCode(65 + index).toLowerCase()}. ",
                                  style: TextStyle(),
                                ),
                                Expanded(
                                  child: Text(e["jawaban"].toString()),
                                )
                              ],
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

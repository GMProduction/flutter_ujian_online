import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      List<Map<String, dynamic>> dummy = DataDummies.ongoingDummy;
      Map<String, dynamic> filter =
          dummy.firstWhere((element) => element["id"] == arguments);
      setState(() {
        soal = filter["soal"][0]["soal"];
        pilihan = filter["soal"][0]["pilihan"];
        listSoal = filter["soal"];
      });
      print(listSoal.length);
    });
  }

  void gantiSoal(int index) {
    setState(() {
      soal = listSoal[index]["soal"];
      pilihan = listSoal[index]["pilihan"];
    });
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
                                  child: Text(e.toString()),
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
                                  "Berikutnya",
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

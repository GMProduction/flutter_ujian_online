import 'package:flutter/material.dart';
import 'package:ujian_online/helper/helper.dart';

class Detail extends StatefulWidget {
  @override
  _DetailState createState() => _DetailState();
}

Map<String, dynamic> ujian = {};

class _DetailState extends State<Detail> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context)!.settings.arguments;
      setState(() {
        ujian = arguments as Map<String, dynamic>;
      });
      print(arguments);
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
                                image: ujian["image"] == null ? NetworkImage(BaseAvatar) : NetworkImage(ujian["image"]),
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
                                ujian["paket"].toString(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                ujian["mapel"].toString(),
                                style: TextStyle(fontSize: 14),
                              ),
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
                                "${ujian["time"].toString()} (Menit)",
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
                      child: Text(
                        ujian["aturan"].toString(),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.justify,
                      ),
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
                  Navigator.pushNamed(context, "/soal", arguments: ujian["id"]);
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

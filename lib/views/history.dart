import 'package:flutter/material.dart';
import 'package:ujian_online/component/bottom_navbar.dart';
import 'package:ujian_online/component/history_card.dart';
import 'package:ujian_online/helper/helper.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
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
                        children: DataDummies.historyDummy.map((history) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/nilai",
                                    arguments: history);
                              },
                              child: HistoryCard(
                                mapel: history["mapel"],
                                paket: history["paket"],
                                nilai: history["nilai"],
                                image: history["image"],
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

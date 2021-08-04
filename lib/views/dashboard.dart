import 'package:flutter/material.dart';
import 'package:ujian_online/component/bottom_navbar.dart';
import 'package:ujian_online/component/ongoing_card.dart';
import 'package:ujian_online/component/profile_navbar.dart';
import 'package:ujian_online/helper/helper.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
                        children: DataDummies.ongoingDummy.map((ujian) {
                          return Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, right: 5),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/detail",
                                    arguments: ujian);
                              },
                              child: ListCard(
                                paket: ujian["paket"].toString(),
                                mapel: ujian["mapel"].toString(),
                                image: ujian["image"].toString(),
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
                      children: DataDummies.upComingDummy.map((ujian) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10, right: 5),
                          child: ListCard(
                            paket: ujian["paket"].toString(),
                            mapel: ujian["mapel"].toString(),
                            image: ujian["image"].toString(),
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

import 'package:flutter/material.dart';
import 'package:ujian_online/component/card.dart';

class ListCard extends StatelessWidget {
  final String paket;
  final String mapel;
  final String image;
  final bool isOngoing;
  final int time;

  const ListCard(
      {Key? key,
      this.paket = "Nama Paket Ujian",
      this.mapel = "Nama Mapel",
      this.time = 0,
      this.image =
          "https://www.smkn63jkt.sch.id/wp-content/uploads/2020/06/ujian-online.png",
      this.isOngoing = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CustomCard(
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 100,
              margin: EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue,
                  image: DecorationImage(
                      image: NetworkImage(this.image), fit: BoxFit.fill)),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Text(
                        this.paket,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      this.mapel,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                )),
                Align(
                  alignment:
                      isOngoing ? Alignment.centerRight : Alignment.centerLeft,
                  child: isOngoing
                      ? Container(
                          height: 20,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.lightBlue),
                          child: Center(
                            child: Text(
                              "Mulai",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          height: 20,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  margin: EdgeInsets.only(right: 5),
                                  child: Icon(
                                    Icons.access_alarm,
                                    size: 12,
                                  )),
                              Text(
                                "${this.time} (Menit)",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        ),
                )
              ],
            ))
          ],
        ));
  }
}

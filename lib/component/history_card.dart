import 'package:flutter/material.dart';
import 'package:ujian_online/component/card.dart';

class HistoryCard extends StatelessWidget {
  final String paket;
  final String mapel;
  final String image;
  final int nilai;

  const HistoryCard(
      {Key? key,
      this.paket = "Nama Paket Ujian",
      this.mapel = "Nama Mapel",
      this.image =
          "https://www.smkn63jkt.sch.id/wp-content/uploads/2020/06/ujian-online.png",
      this.nilai = 0})
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
                    // Text(
                    //   this.mapel,
                    //   style: TextStyle(fontSize: 12),
                    // ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Nilai : ${this.nilai.toString()}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightBlue),
                    child: Center(
                      child: Text(
                        "Lihat Peringkat",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

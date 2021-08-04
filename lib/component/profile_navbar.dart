import 'package:flutter/material.dart';
import 'package:ujian_online/component/circle_logo.dart';
import 'package:ujian_online/helper/helper.dart';

class ProfileNavbar extends StatelessWidget {
  final String avatar;
  final String nama;
  final String kelas;
  final double height;
  final Color background;
  final Color textColor;

  const ProfileNavbar(
      {Key? key,
      this.avatar = BaseAvatar,
      this.nama = 'Siswa',
      this.kelas = 'Kelas Siswa',
      this.height = 75,
      this.background = Colors.white,
      this.textColor = Colors.black})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      color: this.background,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat datang,",
                style: TextStyle(
                    color: this.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "${this.nama} (${this.kelas})",
                style: TextStyle(color: this.textColor, fontSize: 16),
              ),
            ],
          ),
          CircleLogo(image: BaseAvatar, size: 60,)
        ],
      ),
    );
  }
}

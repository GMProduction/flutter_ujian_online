import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ujian_online/helper/helper.dart';
import 'package:image_picker/image_picker.dart';

class Profil extends StatefulWidget {
  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  bool isEditable = false;
  bool onUploadImage = false;
  bool isLoadingSave = false;
  String nama = '';
  String avatar = BaseAvatar;
  String noHp = '';
  String alamat = '';
  String kelas = '';
  DateTime? tanggal;
  TextEditingController textNama = TextEditingController();
  TextEditingController textHp = TextEditingController();
  TextEditingController textAlamat = TextEditingController();
  TextEditingController textKelas = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  void dispose() {
    textNama.dispose();
    textHp.dispose();
    textAlamat.dispose();
    textKelas.dispose();
    super.dispose();
  }

  void getProfile() async {
    String url = "$HostAddress/profile";
    String _token = await GetToken();
    try {
      final response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": "Bearer $_token",
            "Accept": "application/json"
          }));
      setState(() {
        avatar = response.data["payload"]["get_siswa"]["image"] == null
            ? BaseAvatar
            : "$HostImage${response.data["payload"]["get_siswa"]["image"]}";
      });
      textHp.text = response.data["payload"]["get_siswa"]["no_hp"].toString();
      textAlamat.text =
          response.data["payload"]["get_siswa"]["alamat"].toString();
      textNama.text = response.data["payload"]["get_siswa"]["nama"].toString();
      textKelas.text =
          response.data["payload"]["get_siswa"]["kelas"].toString();
      print(response);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengganti Gambar Profil...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, maxWidth: 1800, maxHeight: 1800);
    if (pickedFile != null) {
      upload(File(pickedFile.path));
    }
  }

  void upload(File file) async {
    String url = "$HostAddress/profile/update-image";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String _dataToken = preferences.getString("token") ?? "";
    try {
      setState(() {
        onUploadImage = true;
      });
      String fileName = file.path.split("/").last;
      FormData form = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName)
      });
      final response = await Dio().post(url,
          data: form,
          options: Options(headers: {
            "Authorization": "Bearer $_dataToken",
            "Accept": "application/json"
          }));
      setState(() {
        avatar = "$HostImage${response.data["payload"]["data"].toString()}";
      });
      print("=========uploaded========");
      print(response.data);
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Mengganti Gambar Profil...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print("=========error uploaded==========");
      print(e.response);
    }
    setState(() {
      onUploadImage = false;
    });
  }

  void editProfile() async {
    setState(() {
      isLoadingSave = true;
    });
    try {
      Map<String, dynamic> data = {
        "nama": textNama.text,
        "kelas": textKelas.text,
        "alamat": textAlamat.text,
        "no_hp": textHp.text,
      };
      print(data);
      String url = "$HostAddress/profile";
      String token = await GetToken();
      var formData = FormData.fromMap(data);
      final response = await Dio().post(url,
          data: formData,
          options: Options(headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json"
          }));
      Fluttertoast.showToast(
          msg: "Berhasil Merubah Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(response.data);
      setState(() {
        isEditable = false;
      });
    } on DioError catch (e) {
      Fluttertoast.showToast(
          msg: "Gagal Menyimpan Data...",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
      print(e.response);
    }
    setState(() {
      isLoadingSave = false;
    });
  }

  void logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("token");
    Navigator.pushNamedAndRemoveUntil(
        context, "/login", ModalRoute.withName("/login"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: isEditable
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditable = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Batal")
                                ],
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 16,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text("Edit")
                                ],
                              ),
                            ),
                    ),
                    Text(
                      "Profil",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        logout();
                      },
                      child: Container(
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 16,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Logout")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (!onUploadImage) {
                      _getFromGallery();
                    }
                  },
                  child: onUploadImage
                      ? Container(
                          height: 150,
                          width: 150,
                          child: Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: NetworkImage(avatar),
                                  fit: BoxFit.cover)),
                        ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nama"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textNama,
                      enabled: isEditable,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        contentPadding: EdgeInsets.only(left: 10, right: 10),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Alamat"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textAlamat,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("No. Hp"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textHp,
                      keyboardType: TextInputType.number,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Kelas"),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: textKelas,
                      keyboardType: TextInputType.text,
                      enabled: isEditable,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                    )
                  ],
                ),
              ),
              Visibility(
                visible: isEditable,
                child: Container(
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        if (!isLoadingSave) {
                          editProfile();
                        }
                      },
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: isLoadingSave
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "Loading...",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 24),
                                    )
                                  ],
                                )
                              : Text(
                                  "Simpan",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

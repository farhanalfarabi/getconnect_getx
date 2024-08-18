import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user.dart';
import '../provider/usersP.dart';

class UsersC extends GetxController {
  var users = List<User>.empty().obs;

  void snackBarError(String msg) {
    Get.snackbar(
      "ERROR",
      msg,
      duration: Duration(seconds: 2),
    );
  }

  //!get data from firebase
  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    UserProvider().getData().then((value) {
      if (value.statusCode == 200) {
        Map<String, dynamic> data = value.body;
        data.forEach((key, value) {
          users.add(User(
              id: key,
              name: value['name'],
              email: value['email'],
              phone: value['phone']));
        });
      }
    });
  }

  //! Add Data

  void add(String name, String email, String phone) {
    if (name != '' && email != '' && phone != '') {
      if (email.contains("@")) {
        UserProvider().postData(name, email, phone).then((value) {
          users.add(
            User(
              id: value.body['name'],
              name: name,
              email: email,
              phone: phone,
            ),
          );
        });
        Get.back();
      } else {
        snackBarError("Masukan email valid");
      }
    } else {
      snackBarError("Semua data harus diisi");
    }
  }

  User userById(String id) {
    return users.firstWhere((element) => element.id == id);
  }

  //! Update
  void edit(String id, String name, String email, String phone) {
    if (name != '' && email != '' && phone != '') {
      if (email.contains("@")) {
        UserProvider()
            .editData(id, name, email, phone)
            .then((value) => Get.back());
      } else {
        snackBarError("Masukan email valid");
      }
    } else {
      snackBarError("Semua data harus diisi");
    }
  }

  Future<bool> delete(String id) async {
    bool _deleted = false;
    await Get.defaultDialog(
      title: "DELETE",
      middleText: "Apakah kamu yakin untuk menghapus data user ini?",
      textConfirm: "Ya",
      confirmTextColor: Colors.white,
      onConfirm: () {
        UserProvider().deleteData(id).then((_) {
          users.removeWhere((element) => element.id == id);
          _deleted = true;
        });
        Get.back();
      },
      textCancel: "Tidak",
    );
    return _deleted;
  }
}

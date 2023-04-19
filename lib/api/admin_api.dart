import 'dart:developer';

import 'package:dio/dio.dart';

Dio dio = Dio();

Future<bool> checkAdmin(String uid) async {
  dio.options.headers['content-Type'] = 'application/json';
  try {
    log(uid);
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/admin/check',
        data: {"uid": uid});
    log(response.toString());
    log(response.data['message'].toString());
    return response.data['message'];
  } catch (e) {
    log(e.toString());
    return false;
  }
}

Future<void> addAdmin(
    {required String phone,
    required String email,
    required String displayName,
    required String uid,
    required String photoURL}) async {
  dio.options.headers['content-Type'] = 'application/json';
  try {
    Response response =
        await dio.post('https://client-hive.onrender.com/api/admin/add', data: {
      "phone": phone,
      "email": email,
      "displayName": displayName,
      "uid": uid,
      "photoURL": photoURL
    });
    log(response.data.toString());
  } catch (e) {
    log(e.toString());
  }
}

Future<void> loginAdmin({required String uid, required String token}) async {
  dio.options.headers['Authentication'] = 'Bearer $token';
  dio.options.headers['content-Type'] = 'application/json';
  try {
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/admin/login',
        data: {"uid": uid});
    log(response.data.toString());
  } catch (e) {
    log(e.toString());
  }
}

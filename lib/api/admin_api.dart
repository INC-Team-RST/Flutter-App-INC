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

Future<int?> addAdmin(
    {required String phone,
    required String email,
    required String displayName,
    required String uid,
    required String photoURL,
    required String accessToken}) async {
  dio.options.headers['content-Type'] = 'application/json';
  try {
    Response response =
        await dio.post('https://client-hive.onrender.com/api/admin/add', data: {
      "phone": phone,
      "email": email,
      "display_name": displayName,
      "uid": uid,
      "photoURL": photoURL,
      "token": accessToken,
    });
    log(response.data.toString());
    return response.statusCode;
  } catch (e) {
    log(e.toString());
    throw Exception(e);
  }
}

Future<void> loginAdmin({required String uid, required String token}) async {
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['content-Type'] = 'application/json';
  try {
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/admin/login',
        data: {"uid": uid, "token": token});
    log(response.data.toString());
  } catch (e) {
    log(e.toString());
  }
}

Future<void> updateProfession({required String profession, required String accessToken}) async {
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization']='Bearer $accessToken';
  try {
    Response response = await dio.patch(
        'https://client-hive.onrender.com/api/admin/update',
        data: {"profession": profession});
    log(response.data.toString());
  } catch (e) {
    log(e.toString());
  }
}

Future<void> adminlogout(String accessToken) async{
   
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization']='Bearer $accessToken';
  try{
    Response response = await dio.post('https://client-hive.onrender.com/api/admin/logout', data: {"token": accessToken});
    log(response.toString());
  } catch(e){
    log(e.toString());
  }
}



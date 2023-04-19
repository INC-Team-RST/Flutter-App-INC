import 'dart:developer';

import 'package:darkknightspict/models/admin.dart';
import 'package:dio/dio.dart';


  Dio dio = Dio();

  Future<bool> checkUser({required String uid}) async {
  
    dio.options.headers['content-Type'] = 'application/json';
    try {
      Response response = await dio.post(
          'https://client-hive.onrender.com/api/user/check',
          data: {"uid": uid});
      log(response.toString());
      log(response.data['message'].toString());
      // log(response.message.toString());
      // log(response.data.message);
      return response.data['message'];
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<int?> addUser(
      {required String email,
      required String name,
      required String uid,
      required String phone,
      required String photoURL,
      required String accessToken
      }) async {
    dio.options.headers['content-Type'] = 'application/json';
    try {
      Response response = await dio
          .post('https://client-hive.onrender.com/api/user/add', data: {
        "email": email,
        "name": name,
        "uid": uid,
        "phone": phone,
        "photoURL": photoURL,
        "token": accessToken,
      });
      log(response.data);
      log(response.statusCode.toString());
      return response.statusCode;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<int?> loginUser({required String uid, required String token}) async {
    dio.options.headers['content-Type'] = 'application/json';
    try {
      Response response = await dio.post(
          'https://client-hive.onrender.com/api/user/login',
          data: {"uid": uid, "token": token});
      log(response.data);
      log(response.statusCode.toString());
      return response.statusCode;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }

  Future<List<AdminData>> getAdmin(String token) async {
    List<AdminData> admins = [];
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['content-Type'] = 'application/json';
    log(token);
    try {
      Response response =
          await dio.get('https://client-hive.onrender.com/api/user/admins');
      
      log(response.data.toString());

      for (var data in response.data) {
        AdminData admin = AdminData(
          id: data['id'],
          emailId: data['email'],
          displayName: data['display_name'],
          uid: data['uid'],
          profession: data['profession'],
          photoURL: data['photoURL'],
          phone: data['phone'],
        );
        admins.add(admin);
      }
      return admins;
      
    } catch (e) {
      log(e.toString());
      return [];
    }
  }


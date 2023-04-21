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
    required String accessToken}) async {
  try {
    Response response =
        await dio.post('https://client-hive.onrender.com/api/user/add', data: {
      "email": email,
      "display_name": name,
      "uid": uid,
      "phone": phone,
      "photoURL": photoURL,
      "token": accessToken,
    });
    log(response.toString());
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
    log(response.toString());
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
    log(response.toString());
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

Future<void> userlogout(String accessToken) async {
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $accessToken';
  try {
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/user/logout',
        data: {"token": accessToken});
    log(response.toString());
  } catch (e) {
    log(e.toString());
  }
}

Future<List<AdminData>> getAllAdmins(
    String profession, String accessToken) async {
  dio.options.headers['Authorization'] = 'Bearer $accessToken';
  dio.options.headers['content-Type'] = 'application/json';
  List<AdminData> admins = [];
  try {
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/user/admins/all',
        data: {"profession": profession});

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
    throw Exception(e);
  }
}

Future<void> addAdminData(int id, String token) async {
  try {
     dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['content-Type'] = 'application/json';
    Response response = await dio.post(
        'https://client-hive.onrender.com/api/user/admins',
        data: {"id": id});
    log(response.toString());
  } catch (e) {
    log(e.toString());
  }
}

Future<List<AdminAppointment>> getAdminAppointments(int id, String accessToken) async {
  List<AdminAppointment> appointments = [];
  try{
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization']='Bearer $accessToken';
    Response response = await dio.get('https://client-hive.onrender.com/api/admin/appointment/$id');
    log(response.data.toString());
    for(var data in response.data){
      AdminAppointment appointment = AdminAppointment(
        id: data['id'],
        userId: data['userId'],
        adminId: data['adminId'],
        userName: data['userName'],
        userEmail: data['userEmail'],
        userPhone: data['userPhone'],
        userPhotoURL: data['userPhotoURL'],
        status: data['status'],
        startTime: data['startTime'],
        endTime: data['endTime'],
        date: data['date'],
      );
      appointments.add(appointment);
    }
    log(appointments.toString());
    return appointments;
  }catch(e){
    log(e.toString());
    throw Exception(e);
  }
}
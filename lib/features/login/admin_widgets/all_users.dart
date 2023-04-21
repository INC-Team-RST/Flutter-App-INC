import 'dart:developer';

import '../../../project/bottombar_admin.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List> users;

  Future<List> getUsers() async {
    String? token = await storage.read(key: 'admin_access_token');

    final Dio dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response =
        await dio.get("https://client-hive.onrender.com/api/admin/users");

    log(response.toString());
    log(response.data.toString());

    return response.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: users,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        print(snapshot.data);

        if (snapshot.hasError) {
          return const Center(
            child: Text('Error'),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          if (snapshot.data.length == 0) {
            return const Center(
              child: Text('No users found'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BottomBarCA(
                                UserId: snapshot.data[index]['id'],
                              )));
                },
                child: ListTile(
                  title: Text(snapshot.data[index]['display_name']),
                  subtitle: Text(snapshot.data[index]['email']),
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    ));
  }
}

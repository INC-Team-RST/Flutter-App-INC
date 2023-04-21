import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../project/bottombar_admin.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final storage = const FlutterSecureStorage();
  Future<List>? users;

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
    super.initState();
    users = getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff010413),
      body: FutureBuilder(
        future: users,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error'),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            if (snapshot.data.length == 0) {
              return const Center(
                child: Text(
                  'No Clients have been added yet',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
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
                          userId: snapshot.data[index]['id'],
                          uidClient: snapshot.data[index]['email'],
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(snapshot.data[index]['photoURL']),
                    ),
                    title: Text(
                      snapshot.data[index]['display_name'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      snapshot.data[index]['email'],
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () {
                        // launch('tel:${admins[index].phone}');
                      },
                    ),
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
      ),
    );
  }
}

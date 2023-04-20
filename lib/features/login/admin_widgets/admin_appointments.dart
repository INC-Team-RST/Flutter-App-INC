import 'dart:developer';

import 'package:darkknightspict/features/login/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

final storage = const FlutterSecureStorage();

class AdminAppointments extends StatefulWidget {
  const AdminAppointments({Key? key}) : super(key: key);

  @override
  State<AdminAppointments> createState() => _AdminAppointmentsState();
}

class _AdminAppointmentsState extends State<AdminAppointments> {
  late Future<List> appointments;

  Future<List> getAdminAppointments() async {
    String? token = await storage.read(key: 'admin_access_token');

    final Dio dio = Dio();

    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response =
        await dio.get("https://client-hive.onrender.com/api/admin/appointment");

    log(response.toString());
    log(response.data.toString());

    return response.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appointments = getAdminAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder(
        future: appointments,
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
                child: Text('No Appointments'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Color col = Colors.white;

                if (snapshot.data![index]['status'] == "PENDING") {
                  col = Colors.grey;
                } else if (snapshot.data![index]['status'] == "ACCEPTED") {
                  col = Colors.green;
                } else {
                  col = Colors.red;
                }
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(children: [
                      const Text(
                        "Appointment Date",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(
                            DateTime.parse(snapshot.data![index]['date'])),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Color(0xff5ad0b5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const Text(
                        "Appointment Start Time",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(snapshot.data![index]['startTime'])
                                .toLocal()),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Color(0xff5ad0b5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const Text(
                        "Appointment End Time",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('h:mm a').format(
                            DateTime.parse(snapshot.data![index]['endTime'])
                                .toLocal()),
                        style: const TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Color(0xff5ad0b5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      const Text(
                        "Status",
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        snapshot.data![index]['status'],
                        style: TextStyle(
                          fontFamily: 'Lato',
                          fontSize: 22,
                          color: col,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ]),
                  ),
                );
              },
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

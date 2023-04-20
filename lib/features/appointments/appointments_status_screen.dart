import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../project/drawer.dart';
import 'widgets/slot_booking_widget.dart';

class AppointmentStatus extends StatefulWidget {
  const AppointmentStatus({required this.AdminId});

  final int AdminId;

  @override
  State<AppointmentStatus> createState() => _AppointmentStatusState();
}

class _AppointmentStatusState extends State<AppointmentStatus> {
  String date = DateFormat.yMMMMd().format(DateTime.now()).toString();
  String time = DateFormat.jm().format(DateTime.now()).toString();
  String? status;
  bool? isBooked;
  double xOffeset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double val = 0;
  bool isDrawerOpen = false;
  final user = FirebaseAuth.instance.currentUser;

  late Future<List> appointments;

  Future<List> getAppointments() async {
    String? token = await storage.read(key: 'user_access_token');

    final Dio dio = Dio();

    log(token!.toString());

    dio.options.headers['Authorization'] = 'Bearer $token';

    Response response =
        await dio.get("https://client-hive.onrender.com/api/user/appointment");

    log(response.toString());

    return response.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appointments = getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final rightSlide = MediaQuery.of(context).size.width * 0.7;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AppointmentsHome(
                  adminId: widget.AdminId,
                ),
              ),
            ).then((value) => setState(() {
                  appointments = getAppointments();
                }));
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: const Color(0xff010413),
          child: Stack(
            children: [
              const NavDrawer(),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isDrawerOpen ? 15 : 0),
                  color: const Color(0xff010413),
                ),
                curve: Curves.easeInOut,
                transform: Matrix4.translationValues(xOffeset, yOffset, 0)
                  ..scale(scaleFactor),
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xff010413),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: isDrawerOpen
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        xOffeset = 0;
                                        yOffset = 0;
                                        scaleFactor = 1;
                                        isDrawerOpen = false;
                                        val = 0;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.keyboard_arrow_left_outlined,
                                      size: 35,
                                    ),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      setState(() {
                                        xOffeset = rightSlide;
                                        yOffset = 110;
                                        scaleFactor = 0.7;
                                        isDrawerOpen = true;
                                        val = 1;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.menu,
                                      color: Color(0xff5ad0b5),
                                    ),
                                  ),
                          ),
                          const Text(
                            'Appointments',
                            style: TextStyle(
                              fontFamily: 'Lato',
                              fontSize: 22,
                              color: Color(0xff5ad0b5),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List>(
                      future: appointments,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          return snapshot.data!.length == 0
                              ? const Center(
                                  child: Text(
                                    'No Appointments',
                                    style: TextStyle(
                                      fontFamily: 'Lato',
                                      fontSize: 22,
                                      color: Color(0xff5ad0b5),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      child: Column(children: [
                                        Text(
                                          snapshot.data![index]['date'],
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 22,
                                            color: Color(0xff5ad0b5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index]['startTime'],
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 22,
                                            color: Color(0xff5ad0b5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data![index]['endTime'],
                                          style: const TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 22,
                                            color: Color(0xff5ad0b5),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ]),
                                    );
                                  },
                                );
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

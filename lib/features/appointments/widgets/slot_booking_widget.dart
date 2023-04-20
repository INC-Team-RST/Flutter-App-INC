import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:darkknightspict/models/user.dart';
import 'package:darkknightspict/project/bottombar.dart';
import 'package:darkknightspict/project/drawer.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

DateTime combine(DateTime date, TimeOfDay? time) => DateTime(
    date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);

class AppointmentsHome extends StatefulWidget {
  AppointmentsHome({required this.adminId});

  final int adminId;

  @override
  State<AppointmentsHome> createState() => _AppointmentsHomeState();
}

class _AppointmentsHomeState extends State<AppointmentsHome> {
  late DateTime _myDateTime;
  String date = '_______';
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime appointmentDateTime = DateTime.now();
  double xOffeset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double val = 0;
  bool isDrawerOpen = false;

  String getTiming(String which) {
    if (which == 'start') {
      if (startTime == null) {
        return '___';
      } else if (startTime != null) {
        final hours = startTime.hour.toString().padLeft(2, '0');
        final minutes = startTime.minute.toString().padLeft(2, '0');
        return '$hours: $minutes';
      }
    } else if (which == 'end') {
      if (endTime == null) {
        return '___';
      } else if (endTime != null) {
        final hours = endTime.hour.toString().padLeft(2, '0');
        final minutes = endTime.minute.toString().padLeft(2, '0');
        return '$hours: $minutes';
      }
    }
    return '___';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                child: ListView(
                  children: [
                    Container(
                      color: const Color(0xff403ffc),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.all(15.0),
                          margin: const EdgeInsets.symmetric(horizontal: 37),
                          decoration: const BoxDecoration(
                            color: Color(0xff403ffc),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          width: MediaQuery.of(context).size.width * 0.82,
                          child: Column(
                            children: [
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              Text(
                                'Choose a suitable date',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: height * 0.032,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: height * 0.0384,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff010413),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                onPressed: () async {
                                  _myDateTime = (await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2050),
                                  ))!;
                                  setState(() {
                                    date = DateFormat('dd/MM/yy')
                                        .format(_myDateTime);
                                    appointmentDateTime = _myDateTime;
                                  });
                                },
                                child: const Text('Choose date',
                                    style: TextStyle(fontFamily: 'Lato')),
                              ),
                              Divider(
                                height: height * 0.0384,
                                thickness: 1.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              Text(
                                'Choose the Start Time',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: height * 0.032,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              Text(
                                getTiming("start"),
                                style: TextStyle(
                                  fontSize: height * 0.0384,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff010413),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                onPressed: () async {
                                  final newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  setState(() {
                                    startTime = newTime!;
                                  });
                                },
                                child: const Text(
                                  'Choose timing',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ),
                              Text(
                                'Choose you End Time',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: height * 0.032,
                                  fontFamily: 'Lato',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              Text(
                                getTiming("end"),
                                style: TextStyle(
                                  fontSize: height * 0.0384,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Lato',
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff010413),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25)),
                                ),
                                onPressed: () async {
                                  final newTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  setState(() {
                                    endTime = newTime!;
                                  });
                                },
                                child: const Text(
                                  'Choose timing',
                                  style: TextStyle(
                                    fontFamily: 'Lato',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.0128,
                              ),
                              const Text(
                                'This is not a confirmed appointment. It may vary as per the CA\'s availability',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Lato',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.0384,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var startTimeAppointment =
                                combine(appointmentDateTime, startTime)
                                    .toIso8601String();

                            var endTimeAppointment =
                                combine(appointmentDateTime, endTime)
                                    .toIso8601String();

                            var dateObj = combine(appointmentDateTime,
                                    TimeOfDay(hour: 0, minute: 0))
                                .toIso8601String();

                            log(startTimeAppointment);
                            log(dateObj);
                            log(endTimeAppointment);
                            log(widget.adminId.toString());

                            String? token =
                                await storage.read(key: 'user_access_token');
                            final Dio dio = Dio();

                            dio.options.headers["Authorization"] =
                                "Bearer $token";
                            log(token!.toString());

                            try {
                              Response response = await dio.post(
                                  // "https://client-hive.onrender.com/api/user/appointment",
                                  "http://192.168.1.101:3000/api/user/appointment",
                                  data: {
                                    "date": '${dateObj}Z',
                                    "startTime": '${startTimeAppointment}Z',
                                    "endTime": '${endTimeAppointment}Z',
                                    "admin_id": widget.adminId,
                                  });

                              log(response.data.toString());
                              log(response.statusCode.toString());

                              Navigator.pop(context);
                            } catch (e) {
                              log(e.toString());
                            }
                            // while (Navigator.canPop(context)) {
                            //   Future.delayed(const Duration(microseconds: 10));
                            //   Navigator.pop(context);
                            // }
                            // setState(() {
                            //   pageIndex = 0;
                            // });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.greenAccent.shade400.withOpacity(0.6),
                            shadowColor: Colors.green.shade800,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: Text(
                            'CONFIRM DATE AND TIME',
                            style: TextStyle(
                              fontSize: height * 0.0256,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                      ],
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

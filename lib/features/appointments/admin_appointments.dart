import 'dart:core';
import 'dart:developer';

import 'package:darkknightspict/api/constants.dart';
import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/models/admin.dart';
import 'package:darkknightspict/packages/calender/flutter_clean_calendar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class ClientStatus extends StatefulWidget {
  const ClientStatus({Key? key, required this.UserId}) : super(key: key);

  final int UserId;

  @override
  State<ClientStatus> createState() => _ClientStatusState();
}

class _ClientStatusState extends State<ClientStatus> {
  final Map<DateTime, List<CleanCalendarEvent>> _events = {};
  DateTime? selectedDate = DateTime.now();
  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) {
      return false;
    }

    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<List<AdminAppointment>> getAppointments() async {
    String? admintoken = await storage.read(key: 'admin_access_token');
    log(admintoken.toString());
    var data = await getAdminAppointments(widget.UserId, admintoken!);
    print(data.toString());
    return data;
  }

  @override
  Widget build(BuildContext context) {
    const List<Tab> tabs = <Tab>[
      Tab(
          child: Text(
        'Calendar',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      )),
      Tab(
          child: Text(
        'All appointments',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      ))
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          TabController tabController = DefaultTabController.of(context);
          tabController.addListener(() {});
          return Scaffold(
            backgroundColor: const Color(0xff010413),
            appBar: AppBar(
              backgroundColor: const Color(0xff010413),
              title: const Text(
                'Appointments',
                style: TextStyle(
                    color: Color(0xff5ad0b5),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: 'Lato'),
              ),
              bottom: const TabBar(
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.40,
                      child: Calendar(
                        onDateSelected: (now) {
                          setState(() {
                            selectedDate = now;
                          });
                          // print(selectedDate);
                        },
                        startOnMonday: true,
                        events: _events,
                        selectedColor: const Color(0xff5ad0b5),
                        todayColor: Colors.blue,
                        eventColor: Colors.white,
                        isExpanded: true,
                        expandableDateFormat: 'EEEE, dd. MMMM yyyy',
                        dayOfWeekStyle: const TextStyle(
                            // color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            fontFamily: 'Lato'),
                      ),
                    ),
                    // ignore: avoid_unnecessary_containers
                    const Text(
                      'Accepted Appointments',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: 'Lato'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Expanded(
                      child: FutureBuilder<List<AdminAppointment>>(
                        future: getAppointments(),
                        builder: (context, snapshot) {
                          log(snapshot.data.toString());
                          if (snapshot.hasData) {
                            List<AdminAppointment> appointments =
                                snapshot.data!;
                            return ListView.builder(
                              itemCount: appointments.length,
                              itemBuilder: (context, index) {
                                if (appointments[index].status == "ACCEPTED") {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff403ffc),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          appointments[index].userName,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato'),
                                        ),
                                        subtitle: Text(
                                          appointments[index].userEmail,
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Lato'),
                                        ),
                                        trailing: Text(
                                          appointments[index].status,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.greenAccent,
                                              fontFamily: 'Lato'),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      // child: StreamBuilder(
                      //   stream: FirebaseFirestore.instance
                      //       .collection('Appointments')
                      //       .where('caId',
                      //           isEqualTo:
                      //               FirebaseAuth.instance.currentUser!.uid)
                      //       .where('status', isEqualTo: 'Accepted')
                      //       .snapshots(),
                      //   builder: (ctx, AsyncSnapshot snapshot) {
                      //     if (snapshot.connectionState ==
                      //         ConnectionState.waiting) {
                      //       return const Center(
                      //         child: CircularProgressIndicator(),
                      //       );
                      //     }
                      //     final details = snapshot.data!.docs;
                      //     final height = MediaQuery.of(context).size.height;
                      //     final width = MediaQuery.of(context).size.width;
                      //     return ListView.separated(
                      //       padding: const EdgeInsets.all(15),
                      //       itemCount: details.length,
                      //       itemBuilder: (context, index) {
                      //         return Container(
                      //           child: details[index]['status'] ==
                      //                       'Accepted' &&
                      //                   (isSameDay(
                      //                       selectedDate,
                      //                       details[index]['dateTime']
                      //                           .toDate()))
                      //               ? Container(
                      //                   decoration: BoxDecoration(
                      //                     color: const Color(0xff403ffc)
                      //                         .withOpacity(0.5),
                      //                     borderRadius:
                      //                         BorderRadius.circular(20.0),
                      //                   ),
                      //                   //width: MediaQuery.of(context).size.width*0.82,
                      //                   height: MediaQuery.of(context)
                      //                           .size
                      //                           .height *
                      //                       0.12,
                      //                   child: Row(
                      //                     children: [
                      //                       SizedBox(
                      //                         width: width * 0.05,
                      //                       ),
                      //                       CircleAvatar(
                      //                         radius: width * 0.076,
                      //                         backgroundImage: NetworkImage(
                      //                             details[index]['photoURL']),
                      //                         backgroundColor: Colors
                      //                             .blue, //temporarily added
                      //                       ),
                      //                       SizedBox(
                      //                         width: width * 0.090,
                      //                       ),
                      //                       Column(
                      //                         children: [
                      //                           SizedBox(
                      //                             height: height * 0.015,
                      //                           ),
                      //                           Flexible(
                      //                             child: Text(
                      //                               details[index]
                      //                                   ['displayName'],
                      //                               style: TextStyle(
                      //                                 fontWeight:
                      //                                     FontWeight.w600,
                      //                                 fontSize:
                      //                                     height * 0.028,
                      //                                 fontFamily: 'Lato',
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           SizedBox(
                      //                             height: height * 0.015,
                      //                           ),
                      //                           Flexible(
                      //                             child: Text(
                      //                               details[index]['email'],
                      //                               style: TextStyle(
                      //                                 fontSize:
                      //                                     height * 0.015,
                      //                                 fontFamily: 'Lato',
                      //                                 fontWeight:
                      //                                     FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                           SizedBox(
                      //                             height: height * 0.007,
                      //                           ),
                      //                           Text(
                      //                             'Time: ${DateFormat.jm().format(details[index]['dateTime'].toDate())}',
                      //                             style: TextStyle(
                      //                               fontSize: height * 0.020,
                      //                               fontFamily: 'Lato',
                      //                               fontWeight:
                      //                                   FontWeight.w700,
                      //                             ),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ],
                      //                   ),
                      //                 )
                      //               : null,
                      //         );
                      //       },
                      //       separatorBuilder:
                      //           (BuildContext context, int index) =>
                      //               const Divider(),
                      //     );
                      //   },
                      //       // ),
                      //     ),
                    ),
                  ],
                ),

                Column(
                  children: [
                    Expanded(
                      child: FutureBuilder<List<AdminAppointment>>(
                        future: getAppointments(),
                        builder: (context, snapshot) {
                          log(snapshot.data.toString());
                          if (snapshot.hasData) {
                            List<AdminAppointment> appointments =
                                snapshot.data!;

                            return ListView.builder(
                              itemCount: appointments.length,
                              itemBuilder: (context, index) {
                                if (appointments[index].status == "PENDING") {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: const Color(0xff010413),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xff403ffc)
                                                .withOpacity(0.5),
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  appointments[index].userName,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  appointments[index].userEmail,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      color: Colors.white,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'Date : ${appointments[index].date}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'From : ${appointments[index].startTime}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  'To : ${appointments[index].endTime}',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                      onPressed: () async {
                                                        String? adminToken =
                                                            await storage.read(
                                                                key:
                                                                    'admin_access_token');
                                                        dio.options.headers[
                                                                'content-Type'] =
                                                            'application/json';
                                                        dio.options.headers[
                                                                'Authorization'] =
                                                            'Bearer $adminToken';
                                                        try {
                                                          Response response =
                                                              await dio.patch(
                                                                  '$baseUrl/admin/appointment/${appointments[index].id}',
                                                                  data: {
                                                                "status":
                                                                    "ACCEPTED"
                                                              });
                                                          log(response
                                                              .toString());
                                                          // log(response.data);

                                                          setState(() {
                                                            getAppointments();
                                                          });
                                                        } catch (e) {
                                                          log(e.toString());
                                                        }

                                                        //patch call to change status to accepted
                                                      },
                                                      child: const Text(
                                                        'ACCEPT',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                            fontFamily: 'Lato',
                                                            color: Colors
                                                                .greenAccent),
                                                      )),
                                                  TextButton(
                                                    onPressed: () async {
                                                      String? adminToken =
                                                          await storage.read(
                                                              key:
                                                                  'admin_access_token');
                                                      dio.options.headers[
                                                              'content-Type'] =
                                                          'application/json';
                                                      dio.options.headers[
                                                              'Authorization'] =
                                                          'Bearer $adminToken';
                                                      try {
                                                        Response response =
                                                            await dio.patch(
                                                                '$baseUrl/admin/appointment/${appointments[index].id}',
                                                                data: {
                                                              "status":
                                                                  "REJECTED"
                                                            });
                                                        log(response.data);
                                                      } catch (e) {
                                                        log(e.toString());
                                                      }
                                                    },
                                                    child: const Text(
                                                      'REJECT',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          fontFamily: 'Lato',
                                                          color:
                                                              Colors.redAccent),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  appointments[index].status,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                      color: Colors.yellow,
                                                      fontFamily: 'Lato'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35),
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'No Appointments pending',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Lato'),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('Appointments')
                //       .where('caId',
                //           isEqualTo:
                //               FirebaseAuth.instance.currentUser!.uid.toString())
                //       .where('status', isEqualTo: 'Pending')
                //       .snapshots(),
                //   builder: (ctx, AsyncSnapshot snapshot) {
                //     log(FirebaseAuth.instance.currentUser!.uid);
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(),
                //       );
                //     }
                //     final details = snapshot.data!.docs;
                //     return ListView.builder(
                //       padding: const EdgeInsets.all(15),
                //       itemCount: details.length,
                //       itemBuilder: (context, index) {
                //         return Container(
                //           decoration: BoxDecoration(
                //             color: const Color(0xff403ffc).withOpacity(0.5),
                //             borderRadius: BorderRadius.circular(20.0),
                //           ),
                //           //width: MediaQuery.of(context).size.width*0.82,
                //           height: MediaQuery.of(context).size.height * 0.16,
                //           child: Row(
                //             children: [
                //               const SizedBox(
                //                 width: 20.0,
                //               ),
                //               CircleAvatar(
                //                 radius: 40.0,
                //                 backgroundImage:
                //                     NetworkImage(details[index]['photoURL']),
                //                 backgroundColor:
                //                     Colors.blue, //temporarily added
                //               ),
                //               const SizedBox(
                //                 width: 15.0,
                //               ),
                //               Column(
                //                 children: [
                //                   const SizedBox(
                //                     height: 12.0,
                //                   ),
                //                   Flexible(
                //                     child: Text(
                //                       details[index]['displayName'],
                //                       style: const TextStyle(
                //                         fontWeight: FontWeight.w600,
                //                         fontSize: 22.0,
                //                         fontFamily: 'Lato',
                //                       ),
                //                     ),
                //                   ),
                //                   Flexible(
                //                     child: Text(
                //                       details[index]['email'],
                //                       style: const TextStyle(
                //                         fontSize: 13.0,
                //                         fontFamily: 'Lato',
                //                         fontWeight: FontWeight.w600,
                //                       ),
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     height: 10.0,
                //                   ),
                //                   Text(
                //                     'Date: ${DateFormat.MMMMd().format(details[index]['dateTime'].toDate())}',
                //                     style: const TextStyle(
                //                       fontSize: 15.0,
                //                       fontFamily: 'Lato',
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     height: 10.0,
                //                   ),
                //                   Text(
                //                     'Time: ${DateFormat.jm().format(details[index]['dateTime'].toDate())}',
                //                     style: const TextStyle(
                //                       fontSize: 15.0,
                //                       fontFamily: 'Lato',
                //                       fontWeight: FontWeight.w700,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               const SizedBox(
                //                 width: 10.0,
                //               ),
                //               Column(
                //                 children: [
                //                   const SizedBox(
                //                     height: 10.0,
                //                   ),
                //                   IconButton(
                //                     // accept button
                //                     onPressed: () async {
                //                       await FirebaseFirestore.instance
                //                           .collection('Appointments')
                //                           .doc(details[index]['uid'])
                //                           .update({
                //                         'status': "Accepted",
                //                       });
                //                       await FirebaseFirestore.instance
                //                           .collection('Users')
                //                           .doc(details[index]['uid'])
                //                           .collection('Chats')
                //                           .add({
                //                         "displayName": AdminInfo.displayName,
                //                         "phoneNumber": AdminInfo.phoneNumber,
                //                         "email": AdminInfo.email,
                //                         "photoURL": AdminInfo.photoURL,
                //                         "uid": AdminInfo.uid,
                //                         "createdAt": Timestamp.now(),
                //                         "Message":
                //                             "Your Appoinment has been confirmed!",
                //                       });
                //                       await FirebaseFirestore.instance
                //                           .collection('Users')
                //                           .doc(details[index]['uid'])
                //                           .update({
                //                         "lastMessageTime": Timestamp.now(),
                //                       });
                //                     },
                //                     icon: const Icon(
                //                       Icons.check,
                //                       color: Colors.green,
                //                       size: 35.0,
                //                     ),
                //                   ),
                //                   const SizedBox(
                //                     height: 10.0,
                //                   ),
                //                   IconButton(
                //                     //Delete Button
                //                     onPressed: () async {
                //                       await FirebaseFirestore.instance
                //                           .collection('Appointments')
                //                           .doc(details[index]['uid'])
                //                           .delete();
                //                       await FirebaseFirestore.instance
                //                           .collection('Users')
                //                           .doc(details[index]['uid'])
                //                           .collection('Chats')
                //                           .add({
                //                         "displayName": AdminInfo.displayName,
                //                         "phoneNumber": AdminInfo.phoneNumber,
                //                         "email": AdminInfo.email,
                //                         "photoURL": AdminInfo.photoURL,
                //                         "uid": AdminInfo.uid,
                //                         "createdAt": Timestamp.now(),
                //                         "Message":
                //                             "Sorry for inconvinience, I am a bit busy at that time! Could you book an appointment at any other time perhaps?",
                //                       });
                //                       await FirebaseFirestore.instance
                //                           .collection('Users')
                //                           .doc(details[index]['uid'])
                //                           .update({
                //                         "lastMessageTime": Timestamp.now(),
                //                       });
                //                     },
                //                     icon: const Icon(
                //                       Icons.close,
                //                       color: Colors.red,
                //                       size: 35.0,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}

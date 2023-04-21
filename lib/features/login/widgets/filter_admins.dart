// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import '../../../api/user_api.dart';
import 'select_admin.dart';
import '../../../models/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class FilterAdmin extends StatefulWidget {
  const FilterAdmin({Key? key}) : super(key: key);

  @override
  State<FilterAdmin> createState() => _FilterAdminState();
}

class _FilterAdminState extends State<FilterAdmin> {
  String dropdownValue = 'DOCTOR';
  late Future admins;

  List<String> professions = [
    'DOCTOR',
    'LAWYER',
    'TEACHER',
    'ARCHITECT',
    'CA',
    'POLICY_AGENT',
  ];

  Future<List<AdminData>> getAdminsAll(String profession) async {
    String? token = await storage.read(key: 'user_access_token');
    final admins = await getAllAdmins(profession, token!);
    return admins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'My Admins',
          style: TextStyle(
            color: Color(0xff5ad0b5),
            fontWeight: FontWeight.bold,
            fontSize: 25,
            fontFamily: 'Lato',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              String? token = await storage.read(key: 'user_access_token');

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectAdmin(
                    token: token!,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xff5ad0b5),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xff010413),
      body: Column(
        children: [
          const Text(
            ' Choose the profession of the admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButton(
            items: professions.map(
              (String professions) {
                return DropdownMenuItem(
                    value: professions, child: Text(professions));
              },
            ).toList(),
            onChanged: (String? newValue) {
              setState(
                () {
                  dropdownValue = newValue!;
                },
              );
            },
            value: dropdownValue,
          ),
          // ElevatedButton(
          //   onPressed: () async {
          //     final String? token =
          //         await storage.read(key: 'user_access_token');
          //   },
          //   child: const Text('Search'),
          // ),
          Expanded(
            child: FutureBuilder<List<AdminData>>(
              future: getAdminsAll(dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  log(snapshot.data.toString());
                  List<AdminData> adminList = snapshot.data!;
                  return ListView.builder(
                    itemCount: adminList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          String? token =
                              await storage.read(key: 'user_access_token');
                          await addAdminData(adminList[index].id, token!);
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Card(
                            color: const Color(0xff5ad0b5),
                            elevation: 4.0,
                            // margin: const EdgeInsets.symmetric(
                            //     horizontal: 10.0, vertical: 6.0),
                            child: ListTile(
                              // contentPadding: const EdgeInsets.symmetric(
                              //   horizontal: 20.0,
                              //   vertical: 10.0,
                              // ),
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(adminList[index].photoURL),
                              ),
                              title: Text(
                                adminList[index].displayName,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                adminList[index].emailId,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () {
                                  // launch('tel:${adminList[index].phone}');
                                },
                              ),
                            ),
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
          ),
        ],
      ),
    );
  }
}

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
        actions: [
          IconButton(
              onPressed: () async {
                String? token = await storage.read(key: 'user_access_token');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SelectAdmin(
                              token: token!,
                            )));
              },
              icon: const Icon(Icons.arrow_back_ios, color: Color(0xff5ad0b5))),
        ],
      ),
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
            items: professions.map((String professions) {
              return DropdownMenuItem(
                  value: professions, child: Text(professions));
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            value: dropdownValue,
          ),
          ElevatedButton(
            onPressed: () async {
              final String? token =
                  await storage.read(key: 'user_access_token');
            },
            child: const Text('Search'),
          ),
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
                        child: ListTile(
                          title: Text(adminList[index].displayName),
                          subtitle: Text(adminList[index].profession),
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

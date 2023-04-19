import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/models/admin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

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
  String? token= await storage.read(key: 'user_access_token');
  final admins = await getAllAdmins(profession, token!);
  return admins;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  // setState(() {
                  //   admins = getAllAdmins( dropdownValue, token!);
                  // });
            },
            child: const Text('Search'),
          ),
          Expanded(
            child: FutureBuilder(
              future: getAdminsAll(dropdownValue),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                   log(snapshot.data.toString());
                  //return Container();
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snapshot.data[index].name),
                        subtitle: Text(snapshot.data[index].email),
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

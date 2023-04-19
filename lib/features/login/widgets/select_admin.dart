import 'dart:developer';

import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/features/login/widgets/filter_admins.dart';
import 'package:darkknightspict/models/admin.dart';
import 'package:darkknightspict/project/bottombar.dart';
import 'package:flutter/material.dart';

class SelectAdmin extends StatefulWidget {
  String token;
  SelectAdmin({Key? key, required this.token}) : super(key: key);

  @override
  State<SelectAdmin> createState() => _SelectAdminState();
}

class _SelectAdminState extends State<SelectAdmin> {
  late Future admins;
  //  Future<List<AdminData>> getAdminList(String profession) async {
  // String? token= await storage.read(key: 'user_access_token');
  // final admins = await getAdmin(token!);
  // return admins;
  // }
  // @override
  // void initState() {
  //   admins = getAdmin(widget.token);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
        backgroundColor: const Color(0xff010413),
        title: const Text(
          'My Admins',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
      ),
      body: FutureBuilder<List<AdminData>>(
        future: getAdmin(widget.token),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            log(snapshot.data.toString());
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No Admins Found'),
              );
            }
            List<AdminData> admins = snapshot.data!;
            return ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomBar()));
                  },
                  child: ListTile(
                    title: Text(admins[index].displayName),
                    subtitle: Text(admins[index].profession),
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
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const FilterAdmin()));
          },
          label: const Text('Add Admin')),
    );
  }
}

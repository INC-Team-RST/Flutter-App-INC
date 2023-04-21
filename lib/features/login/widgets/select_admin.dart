import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../api/user_api.dart';
import '../../../models/admin.dart';
import '../../../models/admin_info.dart';
import '../../../models/user.dart';
import '../../../project/bottombar.dart';
import '../login.dart';
import 'filter_admins.dart';

class SelectAdmin extends StatefulWidget {
  final String token;
  const SelectAdmin({Key? key, required this.token}) : super(key: key);

  @override
  State<SelectAdmin> createState() => _SelectAdminState();
}

class _SelectAdminState extends State<SelectAdmin> {
  final storage = const FlutterSecureStorage();
  late Future admins;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              //Log out

              AwesomeDialog(
                context: context,
                dialogType: DialogType.infoReverse,
                animType: AnimType.bottomSlide,
                headerAnimationLoop: false,
                title: 'Signout?',
                desc: 'Do you really want to signout?',
                btnOkOnPress: () async {
                  String? token = await storage.read(key: 'user_access_token');
                  log(token.toString());
                  await userlogout(token!);
                  await storage.delete(key: 'user_type');
                  await GoogleSignIn().signOut();
                  // await GoogleSignIn().disconnect();
                  await _auth.signOut();
                  if (!mounted) return;
                  LocalUser.uid = null;
                  AdminInfo.uid = null;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const LoginScreen()),
                      (route) => false);
                },
                btnCancelOnPress: () {},
                dismissOnTouchOutside: false,
              ).show();
            },
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
      backgroundColor: const Color(0xff010413),
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
            log(admins[0].id.toString());
            return ListView.separated(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomBar(
                          adminID: admins[index].id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(admins[index].photoURL),
                    ),
                    title: Text(
                      admins[index].displayName,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${admins[index].profession} | ${admins[index].emailId}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new_rounded),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomBar(
                              adminID: admins[index].id,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 1,
                  thickness: 1,
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
            Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilterAdmin()))
                .then((value) => setState(() {
                      getAdmin(widget.token);
                    }));
          },
          label: const Text('+ Add Admin')),
    );
  }
}

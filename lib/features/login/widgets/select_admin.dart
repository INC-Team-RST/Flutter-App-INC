import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:darkknightspict/api/user_api.dart';
import 'package:darkknightspict/features/login/login.dart';
import 'package:darkknightspict/features/login/widgets/filter_admins.dart';
import 'package:darkknightspict/models/admin.dart';
import 'package:darkknightspict/models/admin_info.dart';
import 'package:darkknightspict/models/user.dart';
import 'package:darkknightspict/project/bottombar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

final storage= const FlutterSecureStorage();
class SelectAdmin extends StatefulWidget {
  String token;
  SelectAdmin({Key? key, required this.token}) : super(key: key);

  @override
  State<SelectAdmin> createState() => _SelectAdminState();
}

class _SelectAdminState extends State<SelectAdmin> {
  late Future admins;
  final user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                          String? token= await storage.read(key:'user_access_token');
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
            log(admins[0].id.toString()) ;
            return ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomBar(adminID: admins[index].id,)));
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
          label: const Text('+ Add Admin')),
    );
  }
}

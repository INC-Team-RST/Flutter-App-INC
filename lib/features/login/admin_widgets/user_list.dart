import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'admin_appointments.dart';
import 'all_users.dart';
import '../login.dart';
import '../../../models/admin_info.dart';
import '../../../models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../api/admin_api.dart';
import 'file_home.dart';

class UserList extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const UserList();

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  final storage = const FlutterSecureStorage();
  int _selectedIndex = 1;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static const List<Widget> pages = <Widget>[
    FileAdmin(),
    UsersScreen(),
    AdminAppointments()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                  String? token = await storage.read(key: 'admin_access_token');
                  log(token.toString());
                  await adminlogout(token!);
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
          'My Users',
          style: TextStyle(
              color: Color(0xff5ad0b5),
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Lato'),
        ),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff000000),
        type: BottomNavigationBarType.fixed,
        // unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            label: 'Appointments',
          ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

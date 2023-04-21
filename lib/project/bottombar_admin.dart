import 'package:darkknightspict/features/chat/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/appointments/admin_appointments.dart';
import '../features/files/file_home_admin.dart';
import '../features/files/file_home_shared_admin.dart';

class BottomBarCA extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const BottomBarCA({required this.userId, required this.uidClient});

  final String uidClient;

  final int userId;

  @override
  State<BottomBarCA> createState() => _BottomBarCAState();
}

class _BottomBarCAState extends State<BottomBarCA> {
  int _selectedIndex = 1;
  List<Widget> pages = <Widget>[
    // AppointmentsHomeAdmin(),

    // LawsAndActs(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    pages = <Widget>[
      // AppointmentsHomeAdmin(),
      ClientStatus(
        UserId: widget.userId,
      ),
      // VideoAdminScreen(),
      ChatScreen(
        isAdmin: true,
        uidAdmin: FirebaseAuth.instance.currentUser!.email!,
        uidClient: widget.uidClient,
      ),
      FileHomeAdmin(
        userId: widget.userId,
      ),
      GetSharedAdmin(userId: widget.userId)
      // LawsAndActs(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff000000),
        type: BottomNavigationBarType.fixed,
        // unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.event_available_outlined),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.messenger_outline_rounded),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy_outlined),
            label: 'Shared Files',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.book_outlined),
          //   label: 'Laws/Acts',
          // ),
        ],
        currentIndex: _selectedIndex,
        // selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:darkknightspict/features/laws/laws.dart';
import 'package:flutter/material.dart';

import '../features/appointments/admin_appointments.dart';
import '../features/files/file_home_admin.dart';

import '../features/chat/chat_home.dart';

class BottomBarCA extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  BottomBarCA({required this.UserId});

  int UserId;

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

    pages = <Widget>[
    // AppointmentsHomeAdmin(),
    ClientStatus(
      UserId: widget.UserId,
    ),
    ChatHome(),
    FileHomeAdmin(),
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

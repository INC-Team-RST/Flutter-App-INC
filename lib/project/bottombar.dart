import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/appointments/appointments_status_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/files/file_home.dart';
import '../features/files/file_home_shared_user.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({required this.adminID});

  final int adminID;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

int pageIndex = 0;

class _BottomBarState extends State<BottomBar> {
  PageController _pageController = PageController();
  List<Widget> pages = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: pageIndex);
    pages = [
      AppointmentStatus(
        adminId: widget.adminID,
      ),
      ChatScreen(uid: FirebaseAuth.instance.currentUser!.uid.toString()),
      // VideoUserScreen(),
      FileHome(
        adminId: widget.adminID,
      ),
      UserMyDocs(adminId: widget.adminID)
      // const LawsAndActs(),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: gotoPage,
        backgroundColor: const Color(0xff000000),
        // backgroundColor: Colors.white,
        items: const [
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
      ),
      body: PageView(
        onPageChanged: onPageChanged,
        controller: _pageController,
        children: pages,
      ),
    );
  }

  void onPageChanged(int page) {
    setState(() {
      pageIndex = page;
      // print(page);
    });
  }

  void gotoPage(int index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }
}

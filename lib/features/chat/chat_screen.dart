import 'package:flutter/material.dart';

import 'widgets/messages.dart';
import 'widgets/new_message.dart';

class ChatScreen extends StatelessWidget {
  // ChatRoom -> ClientId_AdminId -> Chats

  final String uidClient;
  final String uidAdmin;
  final bool isAdmin;

  const ChatScreen({
    Key? key,
    required this.uidClient,
    required this.uidAdmin,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: const Color(0xff010413),
        body: Column(
          children: [
            Expanded(
              child: Messages(
                uidClient: uidClient,
                uidAdmin: uidAdmin,
                isAdmin: isAdmin,
              ),
            ),
            NewMessage(
              uidClient: uidClient,
              uidAdmin: uidAdmin,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  final String uidClient;
  final String uidAdmin;
  final bool isAdmin;

  const Messages({
    Key? key,
    required this.uidClient,
    required this.uidAdmin,
    required this.isAdmin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FirebaseAuth auth = FirebaseAuth.instance;
    return StreamBuilder(
      // ChatRoom -> ClientId_AdminId -> Chats
      stream: FirebaseFirestore.instance
          .collection('ChatRoom')
          .doc("${uidClient}_$uidAdmin")
          .collection('Chats')
          .orderBy('createdAt', descending: true)
          .snapshots(),

      builder: (ctx, AsyncSnapshot chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        // final user = FirebaseAuth.instance.currentUser;
        return ListView.builder(
          reverse: true,
          itemBuilder: (ctx, index) {
            bool isMe = false;
            if (isAdmin) {
              if (chatDocs[index]['uid'] == uidAdmin) {
                isMe = true;
              }
            } else {
              if (chatDocs[index]['uid'] == uidClient) {
                isMe = true;
              }
            }
            return MessageBubble(
              chatDocs[index]['Message'],
              chatDocs[index]['displayName'],
              chatDocs[index]['photoURL'],
              isMe,
            );
          },
          itemCount: chatDocs.length,
        );
      },
    );
  }
}

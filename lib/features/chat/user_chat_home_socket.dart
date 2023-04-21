// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';

// import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// class ChatUserScreen extends StatefulWidget {
//   ChatUserScreen({required this.client, required this.channel});

//   final StreamChatClient client;

//   /// The channel we'd like to observe and participate.
//   final Channel channel;

//   @override
//   State<ChatUserScreen> createState() => _ChatUserScreenState();
// }

// class _ChatUserScreenState extends State<ChatUserScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       builder: (context, widget) {
//         return StreamChat(
//           client: widget.client,
//           child: widget,
//         );
//       },
//       home: StreamChannel(
//         channel: widget.channel,
//         child: ChannelPage(),
//       ),
//     );
//   }
// }

// class ChannelPage extends StatelessWidget {
//   const ChannelPage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const StreamChannelHeader(),
//       body: Column(
//         children: const <Widget>[
//           Expanded(
//             child: StreamMessageListView(),
//           ),
//           StreamMessageInput(),
//         ],
//       ),
//     );
//   }
// }

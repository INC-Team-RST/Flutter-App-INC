import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

final storage = const FlutterSecureStorage();

class VideoUserScreen extends StatefulWidget {
  @override
  State<VideoUserScreen> createState() => _VideoUserScreenState();
}

class _VideoUserScreenState extends State<VideoUserScreen> {
  Future<bool> getPermissions() async {
    if (Platform.isIOS) return true;
    await Permission.camera.request();
    await Permission.microphone.request();
    await Permission.bluetoothConnect.request();

    while ((await Permission.camera.isDenied)) {
      await Permission.camera.request();
    }
    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
    while ((await Permission.bluetoothConnect.isDenied)) {
      await Permission.bluetoothConnect.request();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Center(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            // Function to push to meeting page
            onPressed: () async {
              await getPermissions();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MeetingPage()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                'Join',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//   late final StreamChatClient client;
//   late final Channel channel;

//   Future<void> connect() async {
//     String? token = await storage.read(key: 'user_access_token');

//     print(token);

//     print("token");

//     await client.connectUser(
//       User(id: '1'),
//       "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMSJ9.n-kO86Mn6V4sJmw5eoexftSNDbYaTOBr1vtGEqZQiNI",
//     );

//     print(client.wsConnectionStatus);
//   }

//   @override
//   void initState() {
//     super.initState();
//     client = StreamChatClient(
//       'qg2jesv426ek',
//       logLevel: Level.INFO,
//     );
//     print(client.wsConnectionStatus);
//     channel =
//         client.channel('messaging', id: 'ruturajsanjayghatage', extraData: {
//       'name': 'Ruturaj Ghatage',
//       'image': 'https://bit.ly/2TIt8NR',
//     });

//     print(channel.client.state.channels);
//     print(channel.client);
//     print(channel.watch());

//     connect();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamChat(
//         client: client,
//         child: StreamChannel(
//           channel: channel,
//           child: const ChannelPage(),
//         ),
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

class MeetingPage extends StatefulWidget {
  const MeetingPage();

  @override
  State<MeetingPage> createState() => _MeetingPageState();
}

class _MeetingPageState extends State<MeetingPage>
    implements HMSUpdateListener {
  //SDK
  late HMSSDK hmsSDK;

  // Variables required for joining a room
  String authToken =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ2ZXJzaW9uIjoyLCJ0eXBlIjoiYXBwIiwiYXBwX2RhdGEiOm51bGwsImFjY2Vzc19rZXkiOiI2NDQyMzUxZTk1ZjE5NGQ1ZTUwOTcxMzEiLCJyb2xlIjoiZ3Vlc3QiLCJyb29tX2lkIjoiNjQ0MjM1MmI4ZWQ0NGY0MzJjN2I5NzFhIiwidXNlcl9pZCI6IjBkZTQ4YzZjLWNjYWQtNGExMS04NDY1LTkwNDg2NzNjYTEzYSIsImV4cCI6MTY4MjE0NzM0OCwianRpIjoiMTJlODk1NTctMjcxZi00ZGFkLThkY2QtNDJjOTNlODlmMmEwIiwiaWF0IjoxNjgyMDYwOTQ4LCJpc3MiOiI2NDQyMzUxZTk1ZjE5NGQ1ZTUwOTcxMmYiLCJuYmYiOjE2ODIwNjA5NDgsInN1YiI6ImFwaSJ9.xXoBOeiV_NYmOIjyRUQW8vRMo2pNm3o9msfm-f6a4Eo";
  String userName = "test_user";

  // Variables required for rendering video and peer info
  HMSPeer? localPeer, remotePeer;
  HMSVideoTrack? localPeerVideoTrack, remotePeerVideoTrack;

  // Initialize variables and join room
  @override
  void initState() {
    super.initState();
    initHMSSDK();
  }

  void initHMSSDK() async {
    hmsSDK = HMSSDK();
    await hmsSDK.build(); // ensure to await while invoking the `build` method
    hmsSDK.addUpdateListener(listener: this);
    hmsSDK.join(config: HMSConfig(authToken: authToken, userName: userName));
  }

  // Clear all variables
  @override
  void dispose() {
    remotePeer = null;
    remotePeerVideoTrack = null;
    localPeer = null;
    localPeerVideoTrack = null;
    super.dispose();
  }

  // Called when peer joined the room - get current state of room by using HMSRoom obj
  @override
  void onJoin({required HMSRoom room}) {
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        localPeer = peer;
        if (peer.videoTrack != null) {
          localPeerVideoTrack = peer.videoTrack;
        }
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  // Called when there's a peer update - use to update local & remote peer variables
  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = peer;
            });
          }
        }
        break;
      case HMSPeerUpdate.peerLeft:
        if (!peer.isLocal) {
          if (mounted) {
            setState(() {
              remotePeer = null;
            });
          }
        }
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        return;
      default:
        if (mounted) {
          setState(() {
            localPeer = null;
          });
        }
    }
  }

  // Called when there's a track update - use to update local & remote track variables
  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      switch (trackUpdate) {
        case HMSTrackUpdate.trackRemoved:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = null
                  : remotePeerVideoTrack = null;
            });
          }
          return;
        default:
          if (mounted) {
            setState(() {
              peer.isLocal
                  ? localPeerVideoTrack = track as HMSVideoTrack
                  : remotePeerVideoTrack = track as HMSVideoTrack;
            });
          }
      }
    }
  }

  // More callbacks - no need to implement for quickstart
  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {}

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {}

  @override
  void onHMSError({required HMSException error}) {}

  @override
  void onMessage({required HMSMessage message}) {}

  @override
  void onReconnected() {}

  @override
  void onReconnecting() {}

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {}

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {}

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {}

  // Widget to render a single video tile
  Widget peerTile(Key key, HMSVideoTrack? videoTrack, HMSPeer? peer) {
    return Container(
      key: key,
      child: (videoTrack != null && !(videoTrack.isMute))
          // Actual widget to render video
          ? HMSVideoView(
              track: videoTrack,
            )
          : Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(4),
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.blue,
                      blurRadius: 20.0,
                      spreadRadius: 5.0,
                    ),
                  ],
                ),
                child: Text(
                  peer?.name.substring(0, 1) ?? "D",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
    );
  }

  // Widget to render grid of peer tiles and a end button
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Used to call "leave room" upon clicking back button [in android]
      onWillPop: () async {
        hmsSDK.leave();
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              // Grid of peer tiles
              Container(
                height: MediaQuery.of(context).size.height,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisExtent: (remotePeerVideoTrack == null)
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height / 2,
                      crossAxisCount: 1),
                  children: [
                    if (remotePeerVideoTrack != null && remotePeer != null)
                      peerTile(
                          Key(remotePeerVideoTrack?.trackId ?? "" "mainVideo"),
                          remotePeerVideoTrack,
                          remotePeer),
                    peerTile(
                        Key(localPeerVideoTrack?.trackId ?? "" "mainVideo"),
                        localPeerVideoTrack,
                        localPeer)
                  ],
                ),
              ),
              // End button to leave the room
              Align(
                alignment: Alignment.bottomCenter,
                child: RawMaterialButton(
                  onPressed: () {
                    hmsSDK.leave();
                    Navigator.pop(context);
                  },
                  elevation: 2.0,
                  fillColor: Colors.red,
                  padding: const EdgeInsets.all(15.0),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.call_end,
                    size: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

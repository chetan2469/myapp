// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';

// import 'package:AgoraStreamDemo/agora/utils/appId.dart';

// class BroadcastPage extends StatefulWidget {
//   final String channelName;
//   final bool isBroadcaster;

//   const BroadcastPage(
//       {Key? key, required this.channelName, required this.isBroadcaster})
//       : super(key: key);

//   @override
//   _BroadcastPageState createState() => _BroadcastPageState();
// }

// class _BroadcastPageState extends State<BroadcastPage> {
//   final _users = <int>[];
//   RtcEngine _engine;
//   bool muted = false;
//   int streamId;

//   @override
//   void dispose() {
//     // clear users
//     _users.clear();
//     // destroy sdk and leave channel
//     _engine.destroy();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     super.initState();
//     // initialize agora sdk
//     initializeAgora();
//   }

//   Future<void> initializeAgora() async {
//     await _initAgoraRtcEngine();

//     if (widget.isBroadcaster)
//       streamId = await _engine.createDataStream(false, false);

//     _engine.setEventHandler(RtcEngineEventHandler(
//       joinChannelSuccess: (channel, uid, elapsed) {
//         setState(() {
//           print('onJoinChannel: $channel, uid: $uid');
//         });
//       },
//       leaveChannel: (stats) {
//         setState(() {
//           print('onLeaveChannel');
//           _users.clear();
//         });
//       },
//       userJoined: (uid, elapsed) {
//         setState(() {
//           print('userJoined: $uid');

//           _users.add(uid);
//         });
//       },
//       userOffline: (uid, elapsed) {
//         setState(() {
//           print('userOffline: $uid');
//           _users.remove(uid);
//         });
//       },
//       streamMessage: (_, __, message) {
//         final String info = "here is the message $message";
//         print(info);
//       },
//       streamMessageError: (_, __, error, ___, ____) {
//         final String info = "here is the error $error";
//         print(info);
//       },
//     ));

//     await _engine.joinChannel(null, widget.channelName, null, 0);
//   }

//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.createWithConfig(RtcEngineConfig(appId));
//     await _engine.enableVideo();

//     await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
//     if (widget.isBroadcaster) {
//       await _engine.setClientRole(ClientRole.Broadcaster);
//     } else {
//       await _engine.setClientRole(ClientRole.Audience);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Stack(
//           children: <Widget>[
//             _broadcastView(),
//             _toolbar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _toolbar() {
//     return widget.isBroadcaster
//         ? Container(
//             alignment: Alignment.bottomCenter,
//             padding: const EdgeInsets.symmetric(vertical: 48),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 RawMaterialButton(
//                   onPressed: _onToggleMute,
//                   child: Icon(
//                     muted ? Icons.mic_off : Icons.mic,
//                     color: muted ? Colors.white : Colors.blueAccent,
//                     size: 20.0,
//                   ),
//                   shape: CircleBorder(),
//                   elevation: 2.0,
//                   fillColor: muted ? Colors.blueAccent : Colors.white,
//                   padding: const EdgeInsets.all(12.0),
//                 ),
//                 RawMaterialButton(
//                   onPressed: () => _onCallEnd(context),
//                   child: Icon(
//                     Icons.call_end,
//                     color: Colors.white,
//                     size: 35.0,
//                   ),
//                   shape: CircleBorder(),
//                   elevation: 2.0,
//                   fillColor: Colors.redAccent,
//                   padding: const EdgeInsets.all(15.0),
//                 ),
//                 RawMaterialButton(
//                   onPressed: _onSwitchCamera,
//                   child: Icon(
//                     Icons.switch_camera,
//                     color: Colors.blueAccent,
//                     size: 20.0,
//                   ),
//                   shape: CircleBorder(),
//                   elevation: 2.0,
//                   fillColor: Colors.white,
//                   padding: const EdgeInsets.all(12.0),
//                 ),
//               ],
//             ),
//           )
//         : Container();
//   }

//   /// Helper function to get list of native views
//   List<Widget> _getRenderViews() {
//     final List<StatefulWidget> list = [];
//     if (widget.isBroadcaster) {
//       list.add(RtcLocalView.SurfaceView());
//     }
//     _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
//     return list;
//   }

//   /// Video view row wrapper
//   Widget _expandedVideoView(List<Widget> views) {
//     final wrappedViews = views
//         .map<Widget>((view) => Expanded(child: Container(child: view)))
//         .toList();
//     return Expanded(
//       child: Row(
//         children: wrappedViews,
//       ),
//     );
//   }

//   /// Video layout wrapper
//   Widget _broadcastView() {
//     final views = _getRenderViews();
//     switch (views.length) {
//       case 1:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoView([views[0]])
//           ],
//         ));
//       case 2:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoView([views[0]]),
//             _expandedVideoView([views[1]])
//           ],
//         ));
//       case 3:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoView(views.sublist(0, 2)),
//             _expandedVideoView(views.sublist(2, 3))
//           ],
//         ));
//       case 4:
//         return Container(
//             child: Column(
//           children: <Widget>[
//             _expandedVideoView(views.sublist(0, 2)),
//             _expandedVideoView(views.sublist(2, 4))
//           ],
//         ));
//       default:
//     }
//     return Container();
//   }

//   void _onCallEnd(BuildContext context) {
//     Navigator.pop(context);
//   }

//   void _onToggleMute() {
//     setState(() {
//       muted = !muted;
//     });
//     _engine.muteLocalAudioStream(muted);
//   }

//   void _onSwitchCamera() {
//     if (streamId != null)
//       _engine.sendStreamMessage(streamId, "mute user blet",
//           data: null, length: null, streamId: null);
//     //_engine.switchCamera();
//   }
// }

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:myapp/agora/utils/appId.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraStreamDemo extends StatefulWidget {
  const AgoraStreamDemo({Key? key}) : super(key: key);

  @override
  State<AgoraStreamDemo> createState() => _AgoraStreamDemoState();
}

class _AgoraStreamDemoState extends State<AgoraStreamDemo> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: Center(
                child: _localUserJoined
                    ? AgoraVideoView(
                        controller: VideoViewController(
                          rtcEngine: _engine,
                          canvas: const VideoCanvas(uid: 0),
                        ),
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

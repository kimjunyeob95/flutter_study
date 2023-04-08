import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_agora_v6/const/agora.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({Key? key}) : super(key: key);

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  RtcEngine? engine;

  // 내 ID
  int? uid = 0;
  // 상대 ID
  int? otherUid;

  @override
  void dispose() async {
    // 채널을 나갈 떄 영상통화와 관련된 모든 리소스를 삭처리
    if (engine != null) {
      await engine!.leaveChannel(
        options: LeaveChannelOptions(),
      );
      engine!.release();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LIVE"),
      ),
      body: FutureBuilder<Object>(
          future: init(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                    child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                            color: Colors.grey,
                            width: 120,
                            height: 160,
                            child: renderSubView())),
                  ],
                )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (engine != null) {
                          await engine!.leaveChannel();
                          engine = null;
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text("채널 나가기")),
                )
              ],
            );
          }),
    );
  }

  Widget renderMainView() {
    if (uid == null) {
      // 채널에 퇴장했을 떄
      return const Center(
        child: Text("채널에 참여해주세요."),
      );
    }
    return AgoraVideoView(
        controller: VideoViewController(
            rtcEngine: engine!,
            canvas: VideoCanvas(
              uid: uid,
            )));
  }

  Widget renderSubView() {
    if (otherUid == null) {
      return const Center(
        child: Text("채널에 상대가 없습니다."),
      );
    }

    return AgoraVideoView(
        controller: VideoViewController.remote(
            rtcEngine: engine!,
            canvas: VideoCanvas(uid: otherUid),
            connection: RtcConnection(channelId: CHANNEL_NAME)));
  }

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();
    final cameraPermission = resp[Permission.camera];
    final microphonePermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted &&
        microphonePermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    if (engine == null) {
      engine = createAgoraRtcEngine();

      await engine!.initialize(RtcEngineContext(
        appId: APP_ID,
      ));

      engine!.registerEventHandler(RtcEngineEventHandler(
        // 내가 채널에 입장 했을 때
        // conneciton > 연결 정보
        // elapsed > 연결된 시간(얼마나 연결되었는지)
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print(
              "내가 채널 입장 | 채널ID: ${connection.channelId}, localUid: ${connection.localUid}");
          setState(() {
            uid = connection.localUid;
          });
        },
        // 내가 채널에서 나갔을 떄
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          print('내가 채널 퇴장');
          setState(() {
            uid = null;
          });
        },
        // 상대방이 들어왔을 떄
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print("상대가 채널에 입장 | uid: $remoteUid");
          setState(() {
            otherUid = remoteUid;
          });
        },
        // 상대가 나갔을 떄
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print("상대가 채널에 퇴장 | uid: $remoteUid | 이유: $reason");
          setState(() {
            otherUid = null;
          });
        },
      ));

      // 비디오를 켜라
      await engine!.enableVideo();
      // 내가 찍는 비디오를 핸드폰에 보여라
      await engine!.startPreview();

      ChannelMediaOptions options = ChannelMediaOptions();

      await engine!.joinChannel(
          token: TEMP_TOKEN, channelId: CHANNEL_NAME, uid: uid!, options: options);
    }

    return true;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';


class Jitse extends StatefulWidget {

  final dynamic data;
  bool pressed=false;
  Jitse({super.key, required this.data,required this.pressed});

  @override
  State<Jitse> createState() => JitseState();
}

class JitseState extends State<Jitse> {
  Map<String, dynamic> payload = {};

  //Joinclass classjoin=Joinclass();
  @override
  void initState() {
    super.initState();

    print("Is pressed is : ${widget.pressed}");
    print("Data of widget is : ${widget.data}");

    String jsonString = widget.data;


    print("Json String is :: $jsonString");

    payload = jsonDecode(jsonString);
    print(payload["title"]);
    String bodyString = (payload['body'].replaceAll("'", '"'));
    payload['body'] = jsonDecode(bodyString);
    print("Data from the loading is $payload");
    print("Data of title is : ${payload['title']}");
    print("Data of payload is : ${payload['body']['room no']}");
    if(widget.pressed){
      join();
    }
  }

  bool audioMuted = true;
  bool videoMuted = true;
  bool screenShareOn = false;
  List<String> participants = [];
  final _jitsiMeetPlugin = JitsiMeet();

  join() async {


    var options = JitsiMeetConferenceOptions(
        serverURL: "https://conference.careaxes.net",
        room: payload['body']['room no'],
        configOverrides: {
          "startWithAudioMuted": true,
          "startWithVideoMuted": true,
        },
        featureFlags: {
          FeatureFlags.addPeopleEnabled: true,
          FeatureFlags.welcomePageEnabled: false,
          FeatureFlags.preJoinPageEnabled: false,
          FeatureFlags.unsafeRoomWarningEnabled: false,
          FeatureFlags.resolution: FeatureFlagVideoResolutions.resolution720p,
          FeatureFlags.audioFocusDisabled: true,
          FeatureFlags.audioMuteButtonEnabled: true,
          FeatureFlags.audioOnlyButtonEnabled: true,
          FeatureFlags.calenderEnabled: true,
          FeatureFlags.callIntegrationEnabled: true,
          FeatureFlags.carModeEnabled: true,
          FeatureFlags.closeCaptionsEnabled: true,
          FeatureFlags.conferenceTimerEnabled: true,
          FeatureFlags.chatEnabled: true,
          FeatureFlags.filmstripEnabled: true,
          FeatureFlags.fullScreenEnabled: true,
          FeatureFlags.helpButtonEnabled: true,
          FeatureFlags.inviteEnabled: false,
          FeatureFlags.androidScreenSharingEnabled: true,
          FeatureFlags.speakerStatsEnabled: true,
          FeatureFlags.kickOutEnabled: true,
          FeatureFlags.liveStreamingEnabled: true,
          FeatureFlags.lobbyModeEnabled: true,
          FeatureFlags.meetingNameEnabled: false,
          FeatureFlags.meetingPasswordEnabled: false,
          FeatureFlags.notificationEnabled: true,
          FeatureFlags.overflowMenuEnabled: true,
          FeatureFlags.pipEnabled: true,
          FeatureFlags.pipWhileScreenSharingEnabled: true,
          FeatureFlags.preJoinPageHideDisplayName: true,
          FeatureFlags.raiseHandEnabled: true,
          FeatureFlags.reactionsEnabled: true,
          FeatureFlags.recordingEnabled: true,
          FeatureFlags.replaceParticipant: true,
          FeatureFlags.securityOptionEnabled: true,
          FeatureFlags.serverUrlChangeEnabled: true,
          FeatureFlags.settingsEnabled: true,
          FeatureFlags.tileViewEnabled: true,
          FeatureFlags.videoMuteEnabled: true,
          FeatureFlags.videoShareEnabled: true,
          FeatureFlags.toolboxEnabled: true,
          FeatureFlags.iosRecordingEnabled: true,
          FeatureFlags.iosScreenSharingEnabled: true,
          FeatureFlags.toolboxAlwaysVisible: true,
        },
        userInfo: JitsiMeetUserInfo(
          displayName: payload['body']['name'][0].toString().toUpperCase(),
          email: payload['body']['name'],
// "https://avatars.githubusercontent.com/u/57035818?s=400&u=02572f10fe61bca6fc20426548f3920d53f79693&v=4"),
        ) );

    var listener = JitsiMeetEventListener(
      conferenceJoined: (url) {
        debugPrint("conferenceJoined: url: $url");
      },
      conferenceTerminated: (url, error) {
        debugPrint("conferenceTerminated: url: $url, error: $error");
      },
      conferenceWillJoin: (url) {
        debugPrint("conferenceWillJoin: url: $url");
      },
      participantJoined: (email, name, role, participantId) {
        debugPrint(
          "participantJoined: email: $email, name: $name, role: $role, "
              "participantId: $participantId",
        );
        participants.add(participantId!);
      },
      participantLeft: (participantId) {
        debugPrint("participantLeft: participantId: $participantId");
      },
      audioMutedChanged: (muted) {
        debugPrint("audioMutedChanged: isMuted: $muted");
      },
      videoMutedChanged: (muted) {
        debugPrint("videoMutedChanged: isMuted: $muted");
      },
      endpointTextMessageReceived: (senderId, message) {
        debugPrint(
            "endpointTextMessageReceived: senderId: $senderId, message: $message");
      },
      screenShareToggled: (participantId, sharing) {
        debugPrint(
          "screenShareToggled: participantId: $participantId, "
              "isSharing: $sharing",
        );
      },
      chatMessageReceived: (senderId, message, isPrivate, timestamp) {
        debugPrint(
          "chatMessageReceived: senderId: $senderId, message: $message, "
              "isPrivate: $isPrivate, timestamp: $timestamp",
        );
      },
      chatToggled: (isOpen) => debugPrint("chatToggled: isOpen: $isOpen"),
      participantsInfoRetrieved: (participantsInfo) {
        debugPrint(
            "participantsInfoRetrieved: participantsInfo: $participantsInfo, ");
      },
      readyToClose: () {
        debugPrint("readyToClose");
      },
    );
    await _jitsiMeetPlugin.join(options, listener);

  }


  hangUp() async {
    await _jitsiMeetPlugin.hangUp();
  }

  setAudioMuted(bool? muted) async {
    var a = await _jitsiMeetPlugin.setAudioMuted(muted!);
    debugPrint("$a");
    setState(() {
      audioMuted = muted;
    });
  }

  setVideoMuted(bool? muted) async {
    var a = await _jitsiMeetPlugin.setVideoMuted(muted!);
    debugPrint("$a");
    setState(() {
      videoMuted = muted;
    });
  }

  sendEndpointTextMessage() async {
    var a = await _jitsiMeetPlugin.sendEndpointTextMessage(message: "HEY");
    debugPrint("$a");

    for (var p in participants) {
      var b =
      await _jitsiMeetPlugin.sendEndpointTextMessage(to: p, message: "HEY");
      debugPrint("$b");
    }
  }

  toggleScreenShare(bool? enabled) async {
    await _jitsiMeetPlugin.toggleScreenShare(enabled!);

    setState(() {
      screenShareOn = enabled;
    });
  }

  openChat() async {
    await _jitsiMeetPlugin.openChat();
  }

  sendChatMessage() async {
    var a = await _jitsiMeetPlugin.sendChatMessage(message: "HEY1");
    debugPrint("$a");

    for (var p in participants) {
      a = await _jitsiMeetPlugin.sendChatMessage(to: p, message: "HEY2");
      debugPrint("$a");
    }
  }

  closeChat() async {
    await _jitsiMeetPlugin.closeChat();
  }

  retrieveParticipantsInfo() async {
    var a = await _jitsiMeetPlugin.retrieveParticipantsInfo();
    debugPrint("$a");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: join,
              child: const Text("Join"),
            ),
            TextButton(onPressed: hangUp, child: const Text("Hang Up")),
            Row(children: [
              const Text("Set Audio Muted"),
              Checkbox(
                value: audioMuted,
                onChanged: setAudioMuted,
              ),
            ]),
            Row(children: [
              const Text("Set Video Muted"),
              Checkbox(
                value: videoMuted,
                onChanged: setVideoMuted,
              ),
            ]),
            TextButton(
              onPressed: sendEndpointTextMessage,
              child: const Text("Send Endpoint Text Message"),
            ),
            TextButton(
              onPressed: () => toggleScreenShare(!screenShareOn),
              child: Text(
                  screenShareOn ? "Stop Screen Share" : "Start Screen Share"),
            ),
            TextButton(onPressed: openChat, child: const Text("Open Chat")),
            TextButton(onPressed: sendChatMessage, child: const Text("Send Chat Message")),
            TextButton(onPressed: closeChat, child: const Text("Close Chat")),
            TextButton(
              onPressed: retrieveParticipantsInfo,
              child: const Text("Retrieve Participants Info"),
            ),
          ],
        ),
      ),
    );
  }
}

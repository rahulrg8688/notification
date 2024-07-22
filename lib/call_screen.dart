import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:uuid/uuid.dart';

import 'navigationService.dart';

class CallScreen {
  late final Uuid _uuid;
  String? _currentUuid;
  RemoteMessage? messagedata;
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isRefreshToken() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("Token refrshed");
    });
  }

  Future<void> requestNotificationPermissions() async {
    print(" i am request permissions");
    if (Platform.isIOS) {
      await messaging.requestPermission(
          alert: true,
          announcement: true,
          badge: true,
          carPlay: true,
          criticalAlert: true,
          provisional: true,
          sound: true
      );
    }
    NotificationSettings notificationSettings = await messaging
        .requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("user has granted permission");
    }
    else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user has already granted provisional permisso");
    }
    else {
      print("user has denied pemission");
    }
  }

  Future foregroundMessage() async {
    print("fore ground");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true
    );
  }

  void firebaseInit(BuildContext context) {
    print("initializing the firebase");
    FirebaseMessaging.onMessage.listen((message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification!.android;
      print("notification title is :: ${notification!.title}");
      print("notificaton body is :: ${notification.body}");
      print("notification data is :: ${message.data.toString()}");
      showCallkitIncoming(Uuid().v4());
      if (Platform.isIOS) {
        foregroundMessage();
      }
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
        messagedata = message;
      }
    });
  }

  void initLocalNotifications(BuildContext context,
      RemoteMessage message) async {

    var androidInitSettings = const AndroidInitializationSettings(
        '@mipmap/ic_launcher');
    var IosInitSettings = const DarwinInitializationSettings();
    var InitSettings = InitializationSettings(
        android: androidInitSettings,
        iOS: IosInitSettings
    );
    await _flutterLocalNotificationsPlugin.initialize(InitSettings,
        onDidReceiveNotificationResponse: (payload) {
          handleMessage(context, message);
        }
    );
  }

  handleMessage(BuildContext context, RemoteMessage message) {
    print("handle message functon");
    if (message.data['type'] == 'text') {
      //redirect to one screen
      print("Handling of message routing");
      Navigator.pushNamed(context, '/jitse');
    }
    if (message.data['type'] == 'call') {
      print("i am at call");
      NavigationService.instance.pushNamedIfNotCurrent('/jitse');
    }
  }

  Future<void> showNotifications(RemoteMessage message) async {
    print("showing notifications");
    AndroidNotificationChannel androidNotificationChannel = AndroidNotificationChannel(
        message.notification!.android!.channelId.toString(),
        message.notification!.android!.channelId.toString(),
        importance: Importance.max,
        showBadge: true,
        playSound: true

    );
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        androidNotificationChannel.id,
        androidNotificationChannel.name,
        channelDescription: 'FLutter Notification',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
        sound: androidNotificationChannel.sound

    );
    const DarwinNotificationDetails darwinNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,

    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
        iOS: darwinNotificationDetails
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0, message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> showCallkitIncoming(String uuid) async {
    print("showing call kit");
    final params = CallKitParams(
      id: uuid,
      nameCaller: 'Hien Nguyen',
      appName: 'Callkit',
      avatar: 'https://i.pravatar.cc/100',
      handle: '0123456789',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
        textColor: '#ffffff',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  // Future<dynamic> getCurrentCall() async {
  //   print("getting current call");
  //   //check current call from pushkit if possible
  //   var calls = await FlutterCallkitIncoming.activeCalls();
  //   print("calls kit is :: $calls");
  //   if (calls is List) {
  //     if (calls.isNotEmpty) {
  //       print('DATA: $calls');
  //       _currentUuid = calls[0]['id'];
  //       return calls[0];
  //     } else {
  //       _currentUuid = "";
  //       return null;
  //     }
  //   }
  // }

  Future<void> checkAndNavigationCallingPage() async {
    print("checking czall and navigate funcn");
   // var currentCall = await getCurrentCall();

        NavigationService.instance.pushNamedIfNotCurrent('/jitse');

    // print("current call is ::: $currentCall");
    // if () {
    //
    // }

        }
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print("state of the application is :: $state");
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage();
    }
  }

  void handleCallEvents() {
    print("handling events");
    FlutterCallkitIncoming.onEvent.listen((event) {
      print("event is :: $event");
      if(event!.event==Event.actionCallAccept){
        checkAndNavigationCallingPage();
      }
      //  switch (event!.event) {
      //     case Event.ACTION_CALL_INCOMING:
      //     // Handle incoming call
      //       break;
      //     case Event.ACTION_CALL_ACCEPT:
      //     // Handle call accepted
      //       print('Call accepted');
      //       // Navigate to the call screen or perform any other action
      //       NavigationService.instance.pushNamed('/jitse', arguments: event.body);
      //       break;
      //     case Event.ACTION_CALL_DECLINE:
      //     // Handle call declined
      //       print('Call declined');
      //       break;
      //     case Event.ACTION_CALL_ENDED:
      //     // Handle call ended
      //       print('Call ended');
      //       break;
      //     case Event.ACTION_CALL_TIMEOUT:
      //     // Handle call timeout
      //       print('Call timed out');
      //       break;
      //     case Event.ACTION_CALL_CALLBACK:
      //     // Handle call callback
      //       print('Call callback');
      //       break;
      //     default:
      //       print('Unhandled event: ${event.event}');
      //       break;
      //   }
    });
  }
}
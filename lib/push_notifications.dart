import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class PushNotification{
  static final _firebaseMessaging=FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationPlugin=FlutterLocalNotificationsPlugin();


  //request notoification
  static Future init() async{
    await _firebaseMessaging.requestPermission(
      alert : true,
      announcement : true,
      badge : true,
      carPlay :false,
      criticalAlert : false,
      provisional : false,
      sound :true,
    );
    final token=await _firebaseMessaging.getToken();
    print("device token : ${token}");
  }

  static Future localNotiInit() async{

    const AndroidInitializationSettings initializationSettingsAndroid=AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin=DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id,title,body,payload)=>null,
    );
    final LinuxInitializationSettings initializationSettingsLinux=LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings=InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux
    );

    await _flutterLocalNotificationPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse:onNotificationTap,
      onDidReceiveBackgroundNotificationResponse:onNotificationTap,
    );
  }

//get the device fcm token
  static  onNotificationTap(NotificationResponse notificationResponse){

// return
// AlertDialog(
//      title: Text("Join Video Call"),
//      content: Text("Do you want to join the video call?"),
//      actions: <Widget>[
//  TextButton(
//  child: Text("No"),
//      onPressed: () {
//    Get.toNamed("/");
//   },
//   ),
//   TextButton(
//   child: Text("Yes"),
//   onPressed: () {
    print("the response of notification is ::: $notificationResponse");
    // navigatorkey.currentState!.pushNamed("/jitse",arguments: notificationResponse);
    //  },
    //  ),
    //  ]
    // ) ;



  }



  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async{
    const AndroidNotificationDetails androidNotificationDetails=AndroidNotificationDetails('Your channel id','your channel name',
        channelDescription: 'Your channel Description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker'
    );
    const NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);

    await _flutterLocalNotificationPlugin.show(0, title, body, notificationDetails,payload: payload);
//navigatorkey.currentState!.pushNamed('/jitse');



  }

}
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:notifications_video_call/push_notifications.dart';

import 'Routes.dart';

import 'firebase_options.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
OverlayEntry? _overlayEntry;
final navigatorkey=GlobalKey<NavigatorState>();
// Future _firebaseBackgroundMsg(RemoteMessage message)async{
//   WidgetsFlutterBinding.ensureInitialized();
//   if(message.notification!=null){
//     print("some notofication received");
//     final context = navigatorkey.currentContext;
//     print("context is ::: $context");
//
//       // _overlayEntry = OverlayEntry(
//       //   builder: (context) => Positioned(
//       //     top: 100,
//       //     left: 100,
//       //     child: Container(
//       //       width: 200,
//       //       height: 200,
//       //       color: Colors.blue,
//       //       child: Text(message.notification!.title.toString()),
//       //     ),
//       //   ),
//       // );
//
//
//     // Overlay.of(context!).insert(_overlayEntry!);
//     var payloadedData={
//       'title': message.notification!.title,
//       'body': message.notification!.body,
//     };
//
//     String payloadData=jsonEncode(payloadedData);
//     print("Navigator key is ::: ${navigatorkey.currentState}");
//     print("Navigator context is n::: ${navigatorkey.currentContext}");
//     Get.toNamed('/message',arguments: payloadData);
//     //Navigator.of(navigatorkey.currentContext!).pushNamed("/message",arguments: payloadData);
//     //navigatorkey.currentState?.pushNamed('/message',arguments: payloadData);
//   }
//   else{
//     print("No notification received");
//   }
// }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    if(message.notification!=null){
      print("Background notification tapped ${message.data}");
      var payloadedData={
        'title': message.notification!.title,
        'body': message.notification!.body,
      };
      print("data is beforeEncode is $payloadedData");

      String payloadData=jsonEncode(payloadedData);
      print("current state is :: ${navigatorkey.currentState}");
      navigatorkey.currentState!.pushNamed("/message",arguments: payloadData);
    }
  });
  PushNotification.init();
  PushNotification.localNotiInit();
 // FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMsg);
  FirebaseMessaging.onMessage.listen((RemoteMessage message){
    print("Message is data ::::: ${message.data}");
    print("message Found 222::::::${message.notification!.body}");

    var payloadedData={
      'title': message.notification!.title,
      'body': message.notification!.body,
    };
    print("data is beforeEncode is $payloadedData");

    String payloadData=jsonEncode(payloadedData);

    print("data is payload : $payloadData");
    print("got a msg in foreground");

    if(message.notification!=null) {
      navigatorkey.currentState!.pushNamed("/message",arguments: payloadData);

      // PushNotification.showSimpleNotification(title: message.notification!.title!, body:message.notification!.body!, payload:payloadData);
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // This widget is the root of your application.
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMsg);
  }
  Future _firebaseBackgroundMsg(RemoteMessage message)async{
    WidgetsFlutterBinding.ensureInitialized();
    if(message.notification!=null){
      print("some notofication received");
      final context = navigatorkey.currentContext;
      print("context is ::: $context");

      _overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 100,
          left: 100,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.blue,
            child: Text(message.notification!.title.toString()),
          ),
        ),
      );


      Overlay.of(context!).insert(_overlayEntry!);
      var payloadedData={
        'title': message.notification!.title,
        'body': message.notification!.body,
      };

      String payloadData=jsonEncode(payloadedData);
      print("Navigator key is ::: ${navigatorkey.currentState}");
      print("Navigator context is n::: ${navigatorkey.currentContext}");
      Get.toNamed('/message',arguments: payloadData);
      //Navigator.of(navigatorkey.currentContext!).pushNamed("/message",arguments: payloadData);
      //navigatorkey.currentState?.pushNamed('/message',arguments: payloadData);
    }
    else{
      print("No notification received");
    }
  }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorkey,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: onGenerate,
    );
  }
}





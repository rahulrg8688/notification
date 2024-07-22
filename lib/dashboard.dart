
import 'package:flutter/material.dart';
import 'package:notifications_video_call/call_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  CallScreen callScreen=CallScreen();
  @override
  void initState(){
    print("I am dashbard");
    // TODO: implement initState
    super.initState();
    callScreen.requestNotificationPermissions();
    callScreen.foregroundMessage();
    callScreen.firebaseInit(context);
    callScreen.getDeviceToken().then((value){
      print("Token value is :: $value");
    });
    callScreen.isRefreshToken();

  WidgetsBinding.instance.addObserver(this);

  callScreen.handleCallEvents();
    }

    @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text("Welcome to dashbioard screen")),
    );
  }
}

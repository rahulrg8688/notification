import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'jitse.dart';
import 'main.dart';

class Message extends StatefulWidget {
  final dynamic data;
  const Message({super.key,required this.data});


  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  Map<String,dynamic> payload={};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      showCustomDialog(context);
    });
    // TODO: implement initState
    super.initState();
  }
  showCustomDialog(BuildContext context){
    final  GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext,
          Animation<double> animation,Animation<double> secondaryAnimation){
        return Center(
          child: Container(
            width: 500,
            height: 600,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Accept the call',
                    style:TextStyle(
                      color:Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,

                    )
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // navigatorkey.currentState!.pop();
                      },
                      child: Text('Decline'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    bool pressed=true;
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context)=>Jitse(
                    //     data:widget.data,pressed:true
                    //   ),)
                    // );
                    Navigator.pushNamed(context, '/jitse',arguments: [
                      widget.data,true
                    ]);
                    // navigatorkey.currentState!.pushNamed('/jitse',arguments: [
                    //   widget.data,true
                    // ]);
                  },
                  child: Text('Accept'),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 200),
    );
  }
  @override
  Widget build(BuildContext context) {




    // final data=ModalRoute.of(context)!.settings.arguments;
    // print("data :::: $data");

    print("payloaded data is : ${payload}");
    print("Data is : $widget.data");
    return Scaffold(
      appBar: AppBar(title: Text("Your message"),),



    );
  }
}

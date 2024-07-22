
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifications_video_call/navigationService.dart';

import 'dashboard.dart';
import 'incoming_call_service.dart';
import 'jitse.dart';
import 'message.dart';

var onGenerate=(RouteSettings settings){
if(settings.name=="/"){
return MaterialPageRoute(builder: (builder)=>Dashboard());
}
else if(settings.name=="/jitse"){

  return MaterialPageRoute(builder: (builder)=>IncomingCallService());
}
else if(settings.name=="/message"){
  return MaterialPageRoute(builder: (builder)=>Message(data: settings.arguments));
}
};
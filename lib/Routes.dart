
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'jitse.dart';
import 'message.dart';

var onGenerate=(RouteSettings settings){
if(settings.name=="/"){
return MaterialPageRoute(builder: (builder)=>Dashboard());
}
else if(settings.name=="/jitse"){
  final args=settings.arguments as List<dynamic>;
  return MaterialPageRoute(builder: (builder)=>Jitse(data : args[0], pressed: args[1],));
}
else if(settings.name=="/message"){
  return MaterialPageRoute(builder: (builder)=>Message(data: settings.arguments));
}
};
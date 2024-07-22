import 'package:flutter/material.dart';

class IncomingCallService extends StatefulWidget {
  const IncomingCallService({super.key});

  @override
  State<IncomingCallService> createState() => _IncomingCallServiceState();
}

class _IncomingCallServiceState extends State<IncomingCallService> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(" i am at calling screen");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Incoming call"),
      ),
    );
  }
}

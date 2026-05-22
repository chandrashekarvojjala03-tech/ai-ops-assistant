import 'package:flutter/material.dart';
import '../services/alert_service.dart';

class IncidentHistoryScreen
extends StatelessWidget {

const IncidentHistoryScreen(
{super.key});

@override
Widget build(BuildContext context){

return Scaffold(

appBar:
AppBar(
title: Text("History")
),

body:
ListView.builder(

itemCount:
AlertService.alerts.length,

itemBuilder:(context,index){

final item=
AlertService.alerts[index];

return ListTile(

leading:
Icon(Icons.history),

title:
Text(item.message),

subtitle:
Text(
"${item.timestamp} | ${item.status}"
),

);

},

),

);

}

}
import 'package:flutter/material.dart';
import '../services/alert_service.dart';

class AlertsScreen extends StatelessWidget {

 const AlertsScreen({super.key});

 @override
 Widget build(BuildContext context){

   return Scaffold(

     appBar:
      AppBar(title: Text("Alerts")),

body:
 ListView.builder(

 itemCount:
 AlertService.alerts.length,

 itemBuilder:(context,index){

 final alert=
 AlertService.alerts[index];

 return Card(

  color:

  alert.severity=="CRITICAL"

      ? Colors.red.withOpacity(0.2)

      : Colors.orange.withOpacity(0.2),

  child: ListTile(

    leading: Icon(

      Icons.warning,

      color:

      alert.severity=="CRITICAL"

          ? Colors.red

          : Colors.orange,

    ),

    title: Text(
      "[${alert.severity}] ${alert.message}"
    ),

    subtitle:
    Text(alert.timestamp),

  ),

);

},

),

);

 }

}
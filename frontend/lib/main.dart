import 'package:flutter/material.dart';

import 'screens/dashboard_screen.dart';
import 'screens/alerts_screen.dart';
import 'screens/incident_history_screen.dart';

void main(){

runApp(
 const MyApp()
);

}

class MyApp extends StatelessWidget{

const MyApp({super.key});

@override
Widget build(BuildContext context){

return MaterialApp(

  debugShowCheckedModeBanner: false,

  theme: ThemeData.dark().copyWith(

    scaffoldBackgroundColor:
        Color(0xFF0B1020),

    appBarTheme: AppBarTheme(
      backgroundColor:
          Color(0xFF0B1020),
    ),

    cardTheme: CardThemeData(
      color: Color(0xFF1E293B),
      elevation: 10,
    ),

  ),

  home: MainScreen(),

);

}
}

class MainScreen extends StatefulWidget{

@override
State<MainScreen>
createState()=>_MainScreenState();

}

class _MainScreenState
extends State<MainScreen>{

int index=0;

final screens=[

DashboardScreen(),

AlertsScreen(),

IncidentHistoryScreen()

];

@override
Widget build(BuildContext context){

return Scaffold(

body:screens[index],

bottomNavigationBar:

BottomNavigationBar(

currentIndex:index,

onTap:(i){

setState((){

index=i;

});

},

items: const [

BottomNavigationBarItem(
icon: Icon(Icons.dashboard),
label: "Dashboard"
),

BottomNavigationBarItem(
icon: Icon(Icons.warning),
label:"Alerts"
),

BottomNavigationBarItem(
icon: Icon(Icons.history),
label:"History"
)

],

),

);

}

}
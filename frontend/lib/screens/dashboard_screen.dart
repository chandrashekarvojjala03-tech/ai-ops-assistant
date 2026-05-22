import 'dart:async';
import 'package:flutter/material.dart';
import '../services/metrics_service.dart';
import '../models/metric_point.dart';
import '../widgets/metric_chart.dart';
import '../services/alert_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  Map<String,dynamic>? metrics;
  List<MetricPoint> history = [];

  Timer? timer;

  Color getColor(value){

 if(value < 50){
   return Colors.green;
 }

 else if(value < 80){
   return Colors.orange;
 }

 return Colors.red;

}

Widget metricCard(
  String title,
  String value,
  IconData icon,
  Color color,
){

 return Card(

   elevation:8,

   shape: RoundedRectangleBorder(
     borderRadius:
       BorderRadius.circular(20),
   ),

   child: Padding(

     padding:
       EdgeInsets.all(20),

     child: Column(

  mainAxisSize: MainAxisSize.min,

  mainAxisAlignment:
      MainAxisAlignment.center,

  children:[

    Icon(
      icon,
      size:32,
      color:color,
    ),

    SizedBox(height:4),

    Text(
      title,
      style: TextStyle(
        fontSize:14,
        fontWeight:
            FontWeight.bold,
      ),
    ),

    SizedBox(height:4),

    Text(
      value,
      style: TextStyle(
        fontSize:18,
        color:color,
        fontWeight:
            FontWeight.bold,
      ),
    ),

    SizedBox(height:2),

    Text(

      double.parse(
        value.replaceAll("%","")
      ) < 50

      ? "Healthy"

      : double.parse(
          value.replaceAll("%","")
        ) < 80

      ? "Warning"

      : "Critical",

      style: TextStyle(
        color:color,
        fontSize:12,
        fontWeight:
            FontWeight.bold,
      ),
    ),

  ],
)
   ),
 );
}

  Widget dashboardRow(
  Widget card,
  Widget chart,
){

 return Row(

   children:[

     Expanded(

       child: SizedBox(

         height:160,

         child: card,

       ),
     ),

     SizedBox(width:20),

     Expanded(

       child: SizedBox(

         height:180,

         child: Card(

           child: Padding(

             padding:
                 EdgeInsets.all(12),

             child: chart,

           ),
         ),
       ),
     ),

   ],
 );
}
  
  void loadData() async {

  final data =
      await MetricsService.fetchMetrics();

  history.add(

    MetricPoint(

      cpu:
      (data['cpu'] as num)
          .toDouble(),

      ram:
      (data['ram'] as num)
          .toDouble(),

      disk:
      (data['disk'] as num)
          .toDouble(),

    ),
  );

  if(history.length>20){

    history.removeAt(0);

  }

  AlertService.checkMetrics(

    cpu:
    (data['cpu'] as num)
        .toDouble(),

    ram:
    (data['ram'] as num)
        .toDouble(),

    disk:
    (data['disk'] as num)
        .toDouble(),
  );

  setState(() {

    metrics=data;

  });

}

  @override
  void initState(){

    super.initState();

    loadData();

    timer=
      Timer.periodic(
  Duration(seconds: 5),
  (timer) async {

    loadData();

  },
);
  }

  @override
  void dispose(){

    timer?.cancel();

    super.dispose();

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar: AppBar(
        title: const Text(
                      "AI Ops Dashboard",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        shadows:[
                          Shadow(
                            blurRadius:20,
                            color: Colors.blue,
                          )
                        ]
                      )
        ),
      ),

      body: metrics == null
      ? Center(
          child: CircularProgressIndicator(),
        )

      : ListView(

         padding: EdgeInsets.all(20),

         children:[

           dashboardRow(

             metricCard(
               "CPU",
               "${metrics!['cpu']}%",
               Icons.memory,
               getColor(metrics!['cpu']),
              ),

        MetricChart(
          values: history
              .map((e)=>e.cpu)
              .toList(),
        ),

      ),

      SizedBox(height:20),

      dashboardRow(

        metricCard(
          "RAM",
          "${metrics!['ram']}%",
          Icons.storage,
          getColor(metrics!['ram']),
        ),

        MetricChart(
          values: history
              .map((e)=>e.ram)
              .toList(),
        ),

      ),

      SizedBox(height:20),

      dashboardRow(

        metricCard(
          "Disk",
          "${metrics!['disk']}%",
          Icons.sd_storage,
          getColor(metrics!['disk']),
        ),

        MetricChart(
          values: history
              .map((e)=>e.disk)
              .toList(),
        ),

      ),

    ],
)
    );
  }
}
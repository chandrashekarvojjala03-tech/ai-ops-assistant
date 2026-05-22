import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MetricChart extends StatelessWidget {

  final List<double> values;

  const MetricChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context){

    return SizedBox(

      height:90,

      child: Padding(

       padding:
        EdgeInsets.all(12),

      child: LineChart(

        LineChartData(

          minY: values.isEmpty
              ? 0
              : values.reduce(
                  (a,b)=>a<b?a:b
                ) - 5,

          maxY: values.isEmpty
              ? 100
              : values.reduce(
                  (a,b)=>a>b?a:b
                ) + 5,
         
          
          clipData:
             FlClipData.all(),

          titlesData: FlTitlesData(

  leftTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    reservedSize: 35,

    getTitlesWidget:
      (value, meta){

        if(value % 10 != 0){

          return SizedBox();

        }

        return Text(
          value.toInt().toString(),
          style: TextStyle(
            fontSize:10,
            color: Colors.white70,
          ),
        );

      },
    ),
  ),
),

  bottomTitles: AxisTitles(
    sideTitles: SideTitles(
      showTitles:true,
      reservedSize:20,

      interval:5,

      getTitlesWidget:
      (value,meta){

        return Text(
          value.toInt().toString(),
          style: TextStyle(
            fontSize:10,
          ),
        );

      },
    ),
  ),

  topTitles: AxisTitles(
    sideTitles:
      SideTitles(
        showTitles:false,
      ),
  ),

  rightTitles: AxisTitles(
    sideTitles:
      SideTitles(
        showTitles:false,
      ),
  ),

),

          borderData:
              FlBorderData(
            show:false,
          ),

          gridData:
              FlGridData(
            show:false,
          ),

          lineBarsData:[

            LineChartBarData(

  isCurved:true,

  barWidth:2,

  preventCurveOverShooting:true,

  dotData:
    FlDotData(
      show:false,
    ),

  belowBarData: BarAreaData(
  show:true,
  cutOffY:0,
),

  spots:
      values
      .asMap()
      .entries
      .map((e){

        return FlSpot(
          e.key.toDouble(),
          e.value,
        );

      }).toList(),
),

          ],
        ),
      ),
    );
  }
}
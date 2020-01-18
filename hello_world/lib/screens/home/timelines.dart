/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Timelines extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         title: Text("Your Timelines"),
         centerTitle: true,
         backgroundColor: Colors.red,
       ),
       body: SafeArea(
         child:Center(
           child: ListView(
             children: <Widget>[
               Padding(
                 padding: EdgeInsets.only(top: 25),
               ),
               Container(
                 height: 300,
                 child: charts.TimeSeriesChart(
                   _createSampleData(),
                   behaviors: [
                     new charts.PanAndZoomBehavior(),
                     new charts.ChartTitle('Your Weight (lbs)',
                         titlePadding: 100,
                         behaviorPosition: charts.BehaviorPosition.start,
                         titleOutsideJustification:
                         charts.OutsideJustification.middleDrawArea),
                     new charts.ChartTitle('Your Weight over Time',
                         behaviorPosition: charts.BehaviorPosition.top,
                         titleOutsideJustification:
                         charts.OutsideJustification.middleDrawArea),
                   ],
                   animate: true,
                   dateTimeFactory: const charts.LocalDateTimeFactory(),

                 ),
               ),
               Padding(
                 padding: EdgeInsets.only(top: 25),
               ),
               Container(
                 height: 300,
                 child: charts.TimeSeriesChart(
                   _createSampleData(),
                   behaviors: [
                     new charts.PanAndZoomBehavior(),
                     new charts.ChartTitle('Your Calories (Cal)',
                         behaviorPosition: charts.BehaviorPosition.start,
                         titleOutsideJustification:
                         charts.OutsideJustification.middleDrawArea),
                     new charts.ChartTitle('Your Calories over Time',
                         behaviorPosition: charts.BehaviorPosition.top,
                         titleOutsideJustification:
                         charts.OutsideJustification.middleDrawArea),
                   ],
                   animate: true,
                   dateTimeFactory: const charts.LocalDateTimeFactory(),
                 ),
               ),
             ],
           ),
         )
       )
    );
  }

  /// Create one series with sample hard coded data.
  static List<charts.Series<TimeSeriesSales, DateTime>> _createSampleData() {
    final data = [
      new TimeSeriesSales(new DateTime(2017, 9, 19), 5),
      new TimeSeriesSales(new DateTime(2017, 9, 26), 25),
      new TimeSeriesSales(new DateTime(2017, 10, 3), 100),
      new TimeSeriesSales(new DateTime(2017, 10, 10), 75),
    ];

    return [
      new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }
}

/// Sample time series data type.
class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}
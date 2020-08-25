import 'package:exodus/models/Activity.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Chart extends StatelessWidget {
  final List<Activity> activities;

  const Chart({Key key, this.activities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
              child: SfCartesianChart(
                title: ChartTitle(text: 'Applicant Graph'),
                legend: Legend(isVisible: true, title: LegendTitle(text: "Applicants") ),
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryXAxis: CategoryAxis(),
                series: <ColumnSeries<Activity, String>>[
                  ColumnSeries<Activity, String>(
                  // Bind data source
                    dataSource: activities,
                    xValueMapper: (Activity activity, _) => activity.title,
                    yValueMapper: (Activity activity, _) => activity.participants.length,
                  )
                ],
              ),
          ),
        ),
      ),
    );
  }
}

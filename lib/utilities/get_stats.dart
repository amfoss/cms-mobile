import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<BarChartGroupData> getWeekData(dailyLog) {
  List<BarChartGroupData> data = [
    for (int i = 23; i < dailyLog.length; i++)
      BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
              y: dailyLog[i]['membersSentCount'].toDouble(),
              color: Colors.lightBlueAccent,
              width: 15.0)
        ],
        showingTooltipIndicators: [0],
      ),
  ];
  return data;
}
List<BarChartGroupData> getMonthData(dailyLog){
  List<double> tempData = getMonthAvg(dailyLog);
  List<BarChartGroupData> monthData = [
    for (int i = 0; i < tempData.length; i++)
    BarChartGroupData(
      x: i,
      barRods: [
        BarChartRodData(
            y: tempData[i],
            color: Colors.lightBlueAccent,
            width: 15.0)
      ],
      showingTooltipIndicators: [0],
    ),
  ];
  return monthData;
}

List<String> getDays(dailyLog) {
  List<String> weekDays = [];
  int length = dailyLog.length - 1;
  DateTime date;
  for (int i = length; i > length - 7 ; i--) {
    date = DateTime.parse(dailyLog[i]['date']);
    switch (DateFormat('EEEE').format(date).toString()) {
      case 'Monday':
        weekDays.add("Mn");
        break;
      case 'Tuesday':
        weekDays.add("Tu");
        break;
      case 'Wednesday':
        weekDays.add("We");
        break;
      case 'Thursday':
        weekDays.add("Th");
        break;
      case 'Friday':
        weekDays.add("Fr");
        break;
      case 'Saturday':
        weekDays.add("Sa");
        break;
      case 'Sunday':
        weekDays.add("Su");
        break;
      default:
        break;
    }
  }
  return weekDays;
}

double getAvg(dailyLog) {
  int sum = 0;
  int length = dailyLog.length - 1;
  for (int i = length; i > length - 7; i--) {
    sum += dailyLog[i]['membersSentCount'];
  }
  return sum / 7;
}

List<double> getMonthAvg(dailyLog){
  List<double> monthAvg = [];
  double sum = 0;
  for(int i=0; i < 28; i+=7){

    sum = (dailyLog[i]['membersSentCount'] + dailyLog[i+1]['membersSentCount']+ dailyLog[i+2]['membersSentCount']+
        dailyLog[i+3]['membersSentCount']+ dailyLog[i+4]['membersSentCount']+ dailyLog[i+5]['membersSentCount']+
        dailyLog[i+6]['membersSentCount'])/7.toInt();
    monthAvg.add(sum);
  }
  return monthAvg;
}

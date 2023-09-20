import 'package:flutter/material.dart';
import 'package:fluttertest/const/colors.dart';
import 'package:fluttertest/model/schedule_with_color.dart';
import 'package:get_it/get_it.dart';
import 'package:fluttertest/database/drift_database.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  const TodayBanner({
    required this.selectedDay,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
    );

    return Container(
      color: PRIMARY_COLOR,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: textStyle,
            ),
            StreamBuilder<List<ScheduleWitchColor>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDay),
              builder: (context, snapshot) {
                int count = 0;

                if(snapshot.hasData){
                  count = snapshot.data!.length;
                }
                return Text(
                  '$count개',
                  style: textStyle,
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:myapp/calender_work/Userdetailcalender.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart' show DateFormat;

class Calender extends StatefulWidget {
  const Calender({super.key});
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TableCalendar(
        rowHeight: 38,
        availableGestures: AvailableGestures.all,
        focusedDay: selectedDay,
        firstDay: DateTime.utc(2023, 1, 1),
        lastDay: DateTime.now(),
        calendarFormat: format,
        onFormatChanged: (CalendarFormat _format) {
          setState(() {
            format = _format;
          });
        },
        onDaySelected: (
          DateTime selectDay,
          DateTime focusDay,
        ) {
          setState(() {
            selectedDay = selectDay;
            focusedDay = focusDay;
            String t = DateFormat('yyyy-dd-MM').format(selectDay);

            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Userdetailcalender(
                      id: "6475d741b99d1a3604d7a9fb", selectedDate: t),
                ));
          });
        },
        selectedDayPredicate: (DateTime data) {
          return isSameDay(selectedDay, data);
        },
        calendarStyle: const CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: Color.fromRGBO(20, 61, 121, 1.0),
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

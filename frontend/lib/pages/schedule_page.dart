import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/ccc/calendar'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        schedules = data.cast<Map<String, dynamic>>();
      });
    } else {
      throw Exception('Failed to fetch schedules');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      body: ListView.builder(
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          return Container(
            // ...
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(schedule['date']),
                  // ...
                ],
              ),
              // ...
            ),
          );
        },
      ),
    );
  }
}

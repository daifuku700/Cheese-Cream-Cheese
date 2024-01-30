import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, String>> events = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    http.Response response =
        await http.get(Uri.parse('http://localhost:8080/ccc/calendar'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        events = jsonData.map<Map<String, String>>((event) {
          return {
            'date': event['date'] as String,
            'summary': event['summary'] as String,
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get today's date
    DateTime today = DateTime.now();

    // Create a list of dates for the next 7 days
    List<DateTime> next7Days =
        List.generate(7, (index) => today.add(Duration(days: index)));

    return Scaffold(
      backgroundColor: Color(0xFFEFF8FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: next7Days.length,
              itemBuilder: (context, index) {
                if (index < events.length) {
                  var date = next7Days[index];
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Added vertical margin
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(events[index]['date'] ?? '',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(events[index]['summary'] ?? '',
                              style: TextStyle(fontSize: 16)),
                          Text('Items to bring: パソコン、ノート、財布'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Add your edit button logic here
                        },
                      ),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if index is out of range
                }
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

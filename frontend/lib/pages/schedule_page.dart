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
  Map<String, List<Map<String, dynamic>>> items = {};
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    fetchData();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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

    // eventsを日付ごとにグループ化
    Map<String, List<Map<String, String>>> groupedEvents = {};
    for (var event in events) {
      if (!groupedEvents.containsKey(event['date'])) {
        groupedEvents[event['date']!] = [event];
      } else {
        groupedEvents[event['date']]?.add(event);
      }
    }

    Map<String, List<Map<String, dynamic>>> groupedItems = {};
    List<Map<String, dynamic>> items = [];
    for (var item in items) {
      if (!groupedItems.containsKey(item['date'])) {
        groupedItems[item['date']] = item['items'];
      } else {
        groupedItems[item['date']]?.addAll(item['items']);
      }
    }

    //controllerをinitializeしなきゃ何故かバグるからここでやっとく
    controller = TextEditingController();

    //カテゴリーごとに適切な色を取得するための関数
    Color _getColorForSummary(String summary) {
      switch (summary) {
        case "授業":
          return Color(0xFF4CAF50); // Green
        case "バイト":
          return Color(0xFFFFC107); // Yellow
        case "打ち上げ":
          return Color(0xFFE91E63); // Pink
        case "試験":
          return Color(0xFF2196F3); // Blue
        case "飲み会":
          return Color(0xFFFF5722); // Orange
        case "MTG":
          return Color(0xFF9C27B0); // Purple
        default:
          return Colors.grey; // Default color for unknown summary
      }
    }

    //持ち物追加する時の関数
    Future<void> addItem(String name) async {
      final String url = 'http://localhost:8080/ccc/insertDB';

      // Example payload for the request
      final Map<String, dynamic> payload = {
        "category": 'exam',
        "name": name,
        "weight": -1,
      };

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Consider checking for other success status codes if applicable
          print('Item added successfully');
        } else {
          print('Failed to add item. Status code: ${response.statusCode}');
          print('Response body: ${response.body}');
          // You might want to log the response body for additional information
          throw Exception('Failed to add item.');
        }
      } catch (error) {
        print('Error adding item: $error');
        // Handle any other errors
      }
    }

    void add() {
      Navigator.of(context).pop(controller.text);
      controller.clear();
    }

    //持ち物追加のポップアップ
    Future<String?> openDialog() => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
              title: Text('持ち物追加'),
              content: TextField(
                decoration: InputDecoration(),
                controller: controller,
                onSubmitted: (_) => add,
              ),
              actions: [
                TextButton(onPressed: add, child: Text('Submit')),
              ]),
        );

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
                var date = next7Days[index];
                var dateString = DateFormat('yyyy-MM-dd').format(date);
                if (groupedEvents.containsKey(dateString)) {
                  var eventsOnDate = groupedEvents[dateString];
                  var itemsOnDate = groupedItems[dateString];
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
                          Text(dateString,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          for (var event in eventsOnDate!)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              height: 20,
                              decoration: BoxDecoration(
                                color:
                                    _getColorForSummary(event['summary'] ?? ''),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Text(
                                  event['summary'] ?? '予定${index + 1}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          //持ち物を表示
                          Center(
                            child: Text(
                              '持ち物', // Add your text here
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          // Expanded(
                          //   // イベントを全て探索
                          //   child: ListView.builder(
                          //     itemCount: events.length,
                          //     itemBuilder: (context, index) {
                          //       // 今日の日付のイベント＆まだ一回も出力してない場合のみアイテムを出力
                          //       if (dateString == events[index]['date'] && events[index]['items'] != null) {
                          //         return Column(
                          //           children: [
                          //             // イベントのアイテムを出力する
                          //             GridView.builder(
                          //               gridDelegate:
                          //                   SliverGridDelegateWithFixedCrossAxisCount(
                          //                 crossAxisCount: 2,
                          //                 mainAxisSpacing:
                          //                     5.0, // Adjust main axis spacing
                          //                 crossAxisSpacing:
                          //                     5.0, // Adjust cross axis spacing
                          //               ),
                          //               shrinkWrap: true,
                          //               physics: const ClampingScrollPhysics(),
                          //               itemCount:
                          //                   events[index]['items']!.length,
                          //               itemBuilder: (context, itemIndex) {
                          //                 final item =
                          //                     events[index]['items']![itemIndex];

                          //                 return Container(
                          //                   margin: const EdgeInsets.symmetric(
                          //                       horizontal: 15),
                          //                   height: 5,
                          //                   width: 5,
                          //                   color: Colors.white,
                          //                   child: Text(
                          //                     item['name'].toString() ?? '',
                          //                     style: TextStyle(
                          //                       fontSize: 20,
                          //                       fontWeight: FontWeight.normal,
                          //                     ),
                          //                     textAlign: TextAlign.center,
                          //                   ),
                          //                 );
                          //               },
                          //             ),
                          //           ],
                          //         );
                          //       } else {
                          //         return Container(); // Return an empty container for events not matching today's date
                          //       }
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () async {
                          final add = await openDialog();
                          if (add == null || add.isEmpty) return;
                          addItem(add);
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

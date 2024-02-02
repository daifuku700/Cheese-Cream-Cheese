import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key, Key? customKey});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, String>> events = [];
  Map<String, List<Map<String, dynamic>>> items = {};
  late TextEditingController controller;
  List<dynamic> jsonData = [];
  bool loading = false;

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
    loading = true;
    http.Response response =
        await http.get(Uri.parse('http://localhost:8080/ccc/calendar'));
    if (response.statusCode == 200) {
      loading = false;
      jsonData = json.decode(response.body);
      setState(() {
        events = jsonData.map<Map<String, String>>((event) {
          return {
            'date': event['date'] as String,
            'summary': event['summary'] as String,
          };
        }).toList();
      });
    } else {
      loading = false;
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
    //loading画面をカッコよくするやつ
    if (loading) {
      return Scaffold(
          backgroundColor: Color(0xFFEFF8FF),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xFFA4D4FF), size: 100),
          ));
    }

    //controllerをinitializeしなきゃ何故かバグるからここでやっとく
    controller = TextEditingController();

    //カテゴリーごとに適切な色を取得するための関数
    Color getColorForSummary(String summary) {
      switch (summary) {
        case "授業":
          return const Color(0xFFA9CF58); // Green
        case "バイト":
          return const Color(0xFFFFC107); // Yellow
        case "打ち上げ":
          return const Color(0xFFFF7575); // Pink
        case "試験":
          return const Color(0xFF75CDFF); // Blue
        case "飲み会":
          return const Color(0xFFFF7575); // Orange
        case "MTG":
          return const Color(0xFFD39CFF); // Purple
        default:
          return Colors.grey; // Default color for unknown summary
      }
    }

    //持ち物追加する時の関数
    Future<void> addItem(String name, String category, String date) async {
      const String url = 'http://localhost:8080/ccc/insertDB';

      // Example payload for the request
      final Map<String, dynamic> payload = {
        "category": category,
        "name": name,
        "weight": 3,
        "event_date": date,
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

    //持ち物追加のポップアップでの追加処理
    void add() {
      Navigator.of(context).pop(controller.text);
      controller.clear();
    }

    //持ち物追加のポップアップ

    Future<String?> openDialog() => showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
              title: const Text('持ち物追加'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    decoration: const InputDecoration(),
                    controller: controller,
                    onSubmitted: (_) => add(),
                  ),
                  // DropdownButton<String>(
                  //   value: addCat,
                  //   items: <String>[
                  //     'exam',
                  //     'class',
                  //     'party',
                  //     'trip',
                  //     'job',
                  //     'mtg',
                  //     'other'
                  //   ].map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       addCat = newValue; // カテゴリーを更新
                  //     });
                  //   },
                  // ),
                  //選択されたカテゴリを表示
                  // if (addCat != null) Text('選択されたカテゴリ: $addCat'),
                ],
              ),
              actions: [
                TextButton(onPressed: () => add(), child: const Text('Submit')),
              ]),
        );

    Set<String> usedDates = {};

    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: next7Days.length,
              itemBuilder: (context, index) {
                var date = next7Days[index];
                var dateString = DateFormat('yyyy-MM-dd').format(date);
                if (groupedEvents.containsKey(dateString)) {
                  var eventsOnDate = groupedEvents[dateString];
                  //var itemsOnDate = groupedItems[dateString];
                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10), // Added vertical margin
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dateString,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    for (var event in eventsOnDate!)
                                      Container(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 10),
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: getColorForSummary(
                                              event['summary'] ?? ''),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            event['summary'] ??
                                                '予定${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    for (var item in jsonData)
                                      if (item["date"] == dateString &&
                                          item["items"] != null &&
                                          !usedDates.contains(dateString) &&
                                          usedDates.add(dateString))
                                        Column(
                                          children: List.generate(
                                              item["items"].length, (index) {
                                            return Text(
                                              item["items"][index]["name"]
                                                  .toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              textAlign: TextAlign.center,
                                            );
                                          }),
                                        ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        height: 56, // 適切な高さに調整してください
                        child: ListView(
                          physics:
                              const NeverScrollableScrollPhysics(), // スクロールを無効にする
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal, // 横方向にスクロールする
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () async {
                                final addIt = await openDialog();
                                if (addIt == null || addIt.isEmpty) return;
                                addItem(addIt, "exam", "2024-02-02");
                                print(addIt);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () async {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container(); // Return an empty container if index is out of range
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

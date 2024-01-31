import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ここにAPIから取得したデータを収納
  List<Map<String, dynamic>> events = [];
  Map<String, dynamic> weather = {};

  @override
  void initState() {
    super.initState();
    fetchEventData();
    fetchWeatherData();
  }

  //スケジュールと持ち物をlocalhostから取得する関数
  Future<void> fetchEventData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/ccc/calendar'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        events = jsonData.map((event) {
          return {
            'summary': event['summary'],
            'date': event['date'],
            'items': (event['items'] as List)
                .map((item) => item.cast<String, dynamic>())
                .toList(),
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  //天気と温度をlocalhostから取得する関数
  Future<void> fetchWeatherData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/ccc/weather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        weather = {
          'area': jsonData['area'] ?? '',
          'temperature_max': jsonData['temperature_max'] ?? '',
          'temperature_min': jsonData['temperature_min'] ?? '',
          'text': jsonData['text'] ?? '',
          'weather_code': jsonData['weather_code'] ?? '',
        };
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  //日にちを表示するための関数
  String _getFormattedDate() {
    initializeDateFormatting(); //これおかなきゃエラーでる
    final now = DateTime.now();
    final formatter = DateFormat('yyyy年MM月dd日EEEE', 'ja_JP');
    return formatter.format(now);
  }

  //天気の画像を変える
  String getImagePath(String weatherText) {
    if (weatherText != null && weatherText.isNotEmpty) {
      switch (weatherText[0]) {
        case '晴':
          return "assets/home_page/sunny.png";
        case '曇':
          return "assets/home_page/cloudy.png";
        case '雨':
          return "assets/home_page/rain.png";
        case '雪':
          return "assets/home_page/snow.png";
        default:
          return "assets/home_page/sunny_cloudy.png";
      }
    } else {
      return "assets/home_page/sunny_cloudy.png";
    }
  }

  @override
  Widget build(BuildContext context) {
    print("hi");
    print(events);
    print(weather);

    return Scaffold(
      backgroundColor: Color(0xFFEFF8FF),
      body: Center(
        child: Column(
          children: <Widget>[
            //おはよう今日は〇〇の所
            Expanded(
              flex: 1,
              child: Container(
                  margin: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5), // Set shadow color
                        spreadRadius: 2, // Set the spread radius of the shadow
                        blurRadius: 5, // Set the blur radius of the shadow
                        offset: Offset(0, 3), // Set the offset of the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'おはよう！\n今日は${_getFormattedDate()}', // Add your text here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ),

            //今日の予定
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Set shadow color
                      spreadRadius: 2, // Set the spread radius of the shadow
                      blurRadius: 5, // Set the blur radius of the shadow
                      offset: Offset(0, 3), // Set the offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      '今日の予定', // Add your text here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    //一つ一つの予定
                    Container(
                      height: 60,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              height: 20,
                              decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Color(0xFFA9CF58)
                                    : Color(0xFF75CDFF),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Center(
                                child: Text(
                                  events[index]['summary'] ?? '予定${index + 1}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Image.asset(
                        getImagePath(weather["text"]),
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                            child: Text(
                          'high: ${weather["temperature_max"] ?? "N/A"}℃\nlow: ${weather["temperature_min"] ?? "N/A"}℃',
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ))),
                  ),
                ],
              ),
            ),

            //持ち物リスト
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.all(15.0),
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
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'これ持った？',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      //イベントを全て探索
                      //TODO: 同日のものだけ表示できるようにさせる
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              //イベント全てのものを出力する
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                itemCount: events[index]['items'].length,
                                itemBuilder: (context, itemIndex) {
                                  final item =
                                      events[index]['items'][itemIndex];

                                  return Row(
                                    children: [
                                      if (itemIndex % 2 == 0)
                                        Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          height: 30,
                                          color: Colors.blue,
                                          child: Text(item['name'] ?? ''),
                                        )
                                      else
                                        Container(
                                          margin:
                                              const EdgeInsets.only(left: 15.0),
                                          height: 30,
                                          color: Colors.green,
                                          child: Text(item['name'] ?? ''),
                                        ),
                                    ],
                                  );
                                },
                              ),

                              // Divider between events
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: Text(
                'いってらっしゃい！',
              ),
            )
          ],
        ),
      ),
    );
  }
}

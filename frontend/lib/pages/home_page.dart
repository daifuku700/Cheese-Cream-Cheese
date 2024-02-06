import 'dart:convert';

import 'package:cream_cheese_cream/pages/HomePageWidgets/home_schedule.dart';
import 'package:cream_cheese_cream/pages/HomePageWidgets/home_to_bring.dart';
import 'package:cream_cheese_cream/pages/HomePageWidgets/home_weather.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'HomePageWidgets/home_today.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ここにAPIから取得したデータを収納
  List<Map<String, dynamic>> events = [];
  Map<String, dynamic> weather = {};
  bool loading = false;

  DateTime currentDate = DateTime.now();

  String currentDateString = "";
  @override
  void initState() {
    super.initState();
    fetchEventData();
    fetchWeatherData();
  }

  //スケジュールと持ち物をlocalhostから取得する関数
  Future<void> fetchEventData() async {
    loading = true;
    final response =
        await http.get(Uri.parse('http://localhost:8080/ccc/calendar'));

    if (response.statusCode == 200) {
      loading = false;
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
      loading = false;
      throw Exception('Failed to load data');
    }
  }

  // 天気と温度を localhost から取得する関数
  Future<void> fetchWeatherData() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/ccc/weather'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      setState(() {
        weather = {
          'area': jsonData['area'] ?? '',
          'temperature_max': jsonData['temp_max'] ?? '',
          'temperature_min': jsonData['temp_min'] ?? '',
          'temperature_max_tomorrow': jsonData['temp_max_tomorrow'] ?? '',
          'temperature_min_tomorrow': jsonData['temp_min_tomorrow'] ?? '',
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

  @override
  Widget build(BuildContext context) {
    currentDateString = _getFormattedDate();

    //ローディング画面
    if (loading) {
      return Scaffold(
          backgroundColor: const Color(0xFFEFF8FF),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: const Color(0xFFA4D4FF), size: 100),
          ));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
      body: Center(
        child: Column(
          children: <Widget>[
            //おはよう今日は〇〇の所
            HomeToday(
              currentDateString: currentDateString,
              homeTodaySize: 1,
            ),

            //今日の予定
            HomeSchedule(
              events: events,
              currentDate: currentDate,
              homeScheduleSize: 2,
            ),

            //天気
            HomeWeather(weather: weather, homeWeatherSize: 2),

            //持ち物リスト
            HomeToBring(events: events, homeToBringSize: 2),

            //いってらっしゃいコメント
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const Text(
                'いってらっしゃい！',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            //ダウンバーのスペースを取るため
            Expanded(flex: 1, child: Container())
          ],
        ),
      ),
    );
  }
}

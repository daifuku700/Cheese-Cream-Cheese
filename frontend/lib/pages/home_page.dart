import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //ここにAPIから取得したデータを収納
  List<Map<String, dynamic>> events = [];
  Map<String, dynamic> weather = {};
  bool displayed = false;
  bool loading = false;

  DateTime currentDate = DateTime.now();
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

  //天気の画像を変える
  String getImagePath(String weatherText) {
    if (weatherText != "" && weatherText.isNotEmpty) {
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

  //温度を取得
  String getTemp(
    String highToday,
    String highTmrw,
    String lowToday,
    String lowTmrw,
  ) {
    String high, low;
    if (highToday != '') {
      high = highToday;
    } else {
      high = highTmrw;
    }
    if (lowToday != '') {
      // Corrected from highToday
      low = lowToday;
    } else {
      low = lowTmrw;
    }
    return '最高気温：$high℃\n最低気温：$low℃';
  }

  //今日か確かめる
  bool isToday(String date) {
    DateTime currentDate = DateTime.now();
    DateTime eventDate = DateTime.parse(date);

    return currentDate.year == eventDate.year &&
        currentDate.month == eventDate.month &&
        currentDate.day == eventDate.day;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
          backgroundColor: Color(0xFFEFF8FF),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
                color: Color(0xFFA4D4FF), size: 100),
          ));
    }

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

    displayed = false;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF8FF),
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
                        offset:
                            const Offset(0, 3), // Set the offset of the shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'おはよう！\n今日は${_getFormattedDate()}', // Add your text here
                      style: const TextStyle(
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
                      offset:
                          const Offset(0, 3), // Set the offset of the shadow
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    const Text(
                      '今日の予定', // Add your text here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    //一つ一つの予定
                    SizedBox(
                      height: 60,
                      child: Scrollbar(
                        child: ListView.builder(
                          itemCount: events.length,
                          itemBuilder: (context, index) {
                            //同日の予定しか表示させないための仕組み
                            DateTime eventDate =
                                DateTime.parse(events[index]['date']);
                            if (eventDate.year == currentDate.year &&
                                eventDate.month == currentDate.month &&
                                eventDate.day == currentDate.day) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                height: 20,
                                decoration: BoxDecoration(
                                  color: getColorForSummary(
                                      events[index]["summary"]),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Center(
                                  child: Text(
                                    events[index]['summary'] ??
                                        '予定${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else {
                              return null;
                            }
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
                        (weather["text"] == null)
                            ? "assets/home_page/loading.gif"
                            : getImagePath(weather["text"]),
                        width: 110,
                        height: 110,
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
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (weather.containsKey('temperature_max') &&
                                  weather.containsKey(
                                      'temperature_max_tomorrow') &&
                                  weather.containsKey('temperature_min') &&
                                  weather
                                      .containsKey('temperature_min_tomorrow'))
                              ? getTemp(
                                  weather['temperature_max'],
                                  weather['temperature_max_tomorrow'],
                                  weather['temperature_min'],
                                  weather['temperature_min_tomorrow'],
                                )
                              : 'Temperature data not available',
                          style: const TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
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
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
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
                      // イベントを全て探索
                      child: ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          // 今日の日付のイベント＆まだ一回も出力してない場合のみアイテムを出力
                          if (isToday(events[index]['date']) && !displayed) {
                            displayed = true;
                            return Column(
                              children: [
                                // イベントのアイテムを出力する
                                GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing:
                                        0.0, // Adjust main axis spacing
                                    crossAxisSpacing:
                                        5.0, // Adjust cross axis spacing
                                    childAspectRatio: 4.5,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: events[index]['items'].length,
                                  itemBuilder: (context, itemIndex) {
                                    final item =
                                        events[index]['items'][itemIndex];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      height: 5,
                                      width: 5,
                                      color: Colors.white,
                                      child: Text(
                                        item['name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.normal,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return Container(); // Return an empty container for events not matching today's date
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 30),
              child: const Text(
                'いってらっしゃい！',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

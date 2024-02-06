import 'package:flutter/material.dart';

class HomeWeather extends StatelessWidget {
  const HomeWeather(
      {super.key, required this.weather, required this.homeWeatherSize});

  final Map<String, dynamic> weather;
  final int homeWeatherSize;
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: homeWeatherSize,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              (weather["text"] == null)
                  ? "assets/home_page/loading.gif"
                  : getImagePath(weather["text"]),
              width: 110,
              height: 110,
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
                          weather.containsKey('temperature_max_tomorrow') &&
                          weather.containsKey('temperature_min') &&
                          weather.containsKey('temperature_min_tomorrow'))
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
    );
  }
}

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'pages/schedule_page.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

//このアプリのテーマみたいなのを決められるやつ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key, required this.title});
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //画面推移に使う関数・配列
  int index = 0;
  final screens = [
    HomePage(),
    SchedulePage(),
  ];
  final display = ['Home', 'Schedule'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //上のバー
      appBar: AppBar(
        backgroundColor: Color(0xFFEFF8FF),
        centerTitle: false,
        title: Text(
          display[index],
          textAlign: TextAlign.left,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),

      //中身（各自のページファイルでいじる）
      body: screens[index],

      //下のナビゲーションバー
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.black,
        backgroundColor: Color(0xFFEFF8FF),
        index: index,
        onTap: (index) => setState(() => this.index = index),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.format_list_bulleted,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

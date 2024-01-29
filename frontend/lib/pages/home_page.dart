import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF8FF),
      body: Center(
          child: Column(
          children: <Widget>[
            //おはよう今日は〇〇の所
            Container(
              margin: const EdgeInsets.all(20.0),
              height: 70,
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
                  'おはよう！\n今日は2024年2月3日土曜日', // Add your text here
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            ),
            //今日の予定
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.all(20.0),
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
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF7575),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          '予定１', // Add your text here
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xFFA9CF58),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          '予定２', // Add your text here
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                      height: 20,
                      decoration: BoxDecoration(
                        color: Color(0xFF75CDFF),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          '予定３', // Add your text here
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                  ),
                ]
              )
            )
          ]
          )
      )
      );
  }
}

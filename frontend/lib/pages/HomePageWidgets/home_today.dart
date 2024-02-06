import 'package:flutter/material.dart';

class HomeToday extends StatelessWidget {
  const HomeToday(
      {super.key,
      required this.currentDateString,
      required this.homeTodaySize});

  final String currentDateString;
  final int homeTodaySize;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: homeTodaySize,
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Set shadow color
                spreadRadius: 2, // Set the spread radius of the shadow
                blurRadius: 5, // Set the blur radius of the shadow
                offset: const Offset(0, 3), // Set the offset of the shadow
              ),
            ],
          ),
          child: Center(
            child: Text(
              'おはよう！\n今日は$currentDateString', // Add your text here
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          )),
    );
  }
}

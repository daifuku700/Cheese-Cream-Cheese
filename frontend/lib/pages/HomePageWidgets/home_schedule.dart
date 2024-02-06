import 'package:flutter/material.dart';

class HomeSchedule extends StatelessWidget {
  const HomeSchedule(
      {super.key,
      required this.events,
      required this.currentDate,
      required this.homeScheduleSize});

  final List<Map<String, dynamic>> events;
  final DateTime currentDate;
  final int homeScheduleSize;

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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: homeScheduleSize,
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
              offset: const Offset(0, 3), // Set the offset of the shadow
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
            Expanded(
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  //同日の予定しか表示させないための仕組み
                  DateTime eventDate = DateTime.parse(events[index]['date']);
                  if (eventDate.year == currentDate.year &&
                      eventDate.month == currentDate.month &&
                      eventDate.day == currentDate.day) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      height: 20,
                      decoration: BoxDecoration(
                        color: getColorForSummary(events[index]["summary"]),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Center(
                        child: Text(
                          events[index]['summary'] ?? '予定${index + 1}',
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
          ],
        ),
      ),
    );
  }
}

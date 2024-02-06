import 'package:flutter/material.dart';

class HomeToBring extends StatefulWidget {
  const HomeToBring({
    super.key,
    required this.events,
    required this.homeToBringSize,
  });
  final List<Map<String, dynamic>> events;
  final int homeToBringSize;
  @override
  State<HomeToBring> createState() => _HomeToBringState();
}

class _HomeToBringState extends State<HomeToBring> {
  bool displayed = false;
  //for check box
  static const int _count = 6;
  final List<bool?> _checks = List.generate(_count, (_) => false);

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
    displayed = false;
    return Expanded(
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
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  // 今日の日付のイベント＆まだ一回も出力してない場合のみアイテムを出力
                  if (isToday(widget.events[index]['date']) && !displayed) {
                    displayed = true;
                    return Column(
                      children: [
                        // イベントのアイテムを出力する
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 20, // Adjust main axis spacing
                            crossAxisSpacing: 2, // Adjust cross axis spacing
                            childAspectRatio: 4.5,
                          ),
                          shrinkWrap: true,
                          itemCount: widget.events[index]['items'].length,
                          itemBuilder: (context, itemIndex) {
                            final item =
                                widget.events[index]['items'][itemIndex];
                            return Container(
                              height: 5,
                              width: 5,
                              color: Colors.white,
                              child: Row(
                                children: [
                                  // Initial state of the checkbox
                                  Checkbox(
                                    activeColor: Color(0xFFA4D4FF),
                                    value: _checks[itemIndex],
                                    onChanged: (newValue) => setState(
                                        () => _checks[itemIndex] = newValue),
                                  ),
                                  Expanded(
                                    child: Text(
                                      item['name'] ?? '',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  // アイコンとテキストの間隔を設定します
                                ],
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
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      body: ListView(
        padding: EdgeInsets.all(8), // Add padding to create space between cards
        children: [
          Card(
            margin: EdgeInsets.symmetric(
                horizontal: 20), // Add margin to create space between cards
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Schedule: 線形代数講義、バイト、打ち上げ'),
                  Text('Items to bring: パソコン、ノート、財布'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Add your edit button logic here
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            margin: EdgeInsets.symmetric(
                horizontal: 20), // Add margin to create space between cards
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Schedule'),
                  Text('Items to bring'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            margin: EdgeInsets.symmetric(
                horizontal: 20), // Add margin to create space between cards
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Schedule'),
                  Text('Items to bring'),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

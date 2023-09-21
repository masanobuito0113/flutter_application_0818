import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';
import 'top.dart';

void main() {
  runApp(const SchedulePage());
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<DateTime, List> _eventsList = {};

  DateTime _focused = DateTime.now();
  DateTime? _selected;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();

    _selected = _focused;
    _eventsList = {
      DateTime.now().subtract(Duration(days: 2)): ['Test A', 'Test B'],
      DateTime.now(): ['Test C', 'Test D', 'Test E', 'Test F'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List getEvent(DateTime day) {
      return _events[day] ?? [];
    }

return Scaffold(
  appBar: AppBar(
    leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TopPage()),
      );
      },
    ),
    title: Text(widget.title),
  ),
  body: Column(children: [
    TableCalendar(
      firstDay: DateTime.utc(2022, 4, 1),
      lastDay: DateTime.utc(2025, 12, 31),
      eventLoader: getEvent, //追記
      selectedDayPredicate: (day) {
        return isSameDay(_selected, day);
      },
      onDaySelected: (selected, focused) {
        if (!isSameDay(_selected, selected)) {
          setState(() {
            _selected = selected;
            _focused = focused;
          });
        }
      },
      focusedDay: _focused,
    ),
    
    ListView(
      shrinkWrap: true,
      children: getEvent(_selected!)
          .map((event) => ListTile(
                title: Text(event.toString()),
              ))
          .toList(),
    )
    
  ]),
);

  }
}
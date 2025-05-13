import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(GratitudeJournalApp());
}

class GratitudeJournalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gratitude Journal',
      debugShowCheckedModeBanner: false,
      home: GratitudeJournalScreen(),
    );
  }
}

class GratitudeJournalScreen extends StatefulWidget {
  @override
  _GratitudeJournalScreenState createState() => _GratitudeJournalScreenState();
}

class _GratitudeJournalScreenState extends State<GratitudeJournalScreen> {
  final TextEditingController _controller = TextEditingController();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  Map<String, List<String>> _gratitudeMap = {};

  List<String> get _selectedDayNotes {
    final key = DateFormat('yyyy-MM-dd').format(_selectedDay);
    return _gratitudeMap[key] ?? [];
  }

  void _addGratitudeNote() {
    final text = _controller.text.trim();
    final key = DateFormat('yyyy-MM-dd').format(_selectedDay);

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter something first.')),
      );
      return;
    }

    if (_gratitudeMap[key] != null && _gratitudeMap[key]!.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You can only add 3 notes per day.')),
      );
      return;
    }

    setState(() {
      _gratitudeMap.putIfAbsent(key, () => []);
      _gratitudeMap[key]!.add(text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gratitude Journal'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Compact calendar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Colors.teal,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.teal.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  weekendTextStyle: TextStyle(color: Colors.red),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Smaller header
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, size: 20),
                  rightChevronIcon: Icon(Icons.chevron_right, size: 20),
                  headerPadding: EdgeInsets.symmetric(vertical: 8),
                ),
                calendarBuilders: CalendarBuilders(
                  defaultBuilder: (context, day, focusedDay) => Center(
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                rowHeight: 36, // Smaller row height
              ),
            ),

            Divider(),

            // Input section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Write 3 things you\'re grateful for:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            hintText: 'Enter a gratitude note...',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) => _addGratitudeNote(),
                        ),
                      ),
                      SizedBox(width: 8),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: _addGratitudeNote,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(),

            // Notes section
            Expanded(
              child: _selectedDayNotes.isEmpty
                  ? Center(
                child: Text(
                  'No notes for this day.',
                  style: TextStyle(color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.only(bottom: 16),
                itemCount: _selectedDayNotes.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.teal.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      dense: true,
                      leading: Icon(Icons.favorite,
                          color: Colors.teal, size: 20),
                      title: Text(
                        _selectedDayNotes[index],
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
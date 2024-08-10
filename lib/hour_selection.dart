import 'package:flutter/material.dart';
import 'iniciar_encerrar.dart';

class HourSelectionPage extends StatefulWidget {
  @override
  _HourSelectionPageState createState() => _HourSelectionPageState();
}

class _HourSelectionPageState extends State<HourSelectionPage> {
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Work Hours'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select your work hours for the day:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Hours: ${_selectedTime.hour} Hours, ${_selectedTime.minute} Minutes',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Pick time
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                );

                if (time != null && time != _selectedTime) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Text('Pick Work Hours'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpedientePage(
                      workHours: _selectedTime,
                    ),
                  ),
                );
              },
              child: Text('Proceed to Expediente'),
            ),
          ],
        ),
      ),
    );
  }
}

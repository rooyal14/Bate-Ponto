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
        title: Text('Selecionar Horas de Trabalho'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecione suas horas de trabalho para o dia:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Horas: ${_selectedTime.hour.toString().padLeft(2, '0')} Horas, ${_selectedTime.minute.toString().padLeft(2, '0')} Minutos',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Pick time
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _selectedTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (time != null && time != _selectedTime) {
                  setState(() {
                    _selectedTime = time;
                  });
                }
              },
              child: Text('Escolher Horas de Trabalho'),
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
              child: Text('Prosseguir para Expediente'),
            ),
          ],
        ),
      ),
    );
  }
}

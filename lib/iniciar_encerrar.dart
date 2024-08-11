import 'package:flutter/material.dart';

class ExpedientePage extends StatefulWidget {
  final TimeOfDay workHours;
  final TimeOfDay endHours;

  ExpedientePage({required this.workHours, required this.endHours});

  @override
  _ExpedientePageState createState() => _ExpedientePageState();
}

class _ExpedientePageState extends State<ExpedientePage> {
  bool isIniciarEnabled = true;
  bool isEncerrarEnabled = false;

  String? iniciarTime;
  String? encerrarTime;
  Duration? workedDuration;

  DateTime? startTime;
  DateTime? endTime;

  void _toggleButtons() {
    setState(() {
      if (isIniciarEnabled) {
        // Store the start time and display it
        startTime = DateTime.now();
        iniciarTime = '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
      } else {
        // Store the end time and calculate the duration
        endTime = DateTime.now();
        encerrarTime = '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
        workedDuration = endTime!.difference(startTime!);
      }

      // Toggle the button states
      isIniciarEnabled = !isIniciarEnabled;
      isEncerrarEnabled = !isEncerrarEnabled;
    });
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    // Calculate total work time as a Duration
    final totalWorkTime = Duration(
      hours: widget.workHours.hour,
      minutes: widget.workHours.minute,
    );

    final totalEndTime = Duration(
      hours: widget.endHours.hour,
      minutes: widget.endHours.minute,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Expediente'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the daily goal in the middle of the screen
            Text(
              'Meta diária: ${_formatDuration(totalWorkTime)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Horário de saída: ${_formatDuration(totalEndTime)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            // Create a grid layout with two columns
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50, // Fixed height for time display
                        alignment: Alignment.center,
                        child: Text(
                          iniciarTime != null ? 'Iniciado às: $iniciarTime' : '',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isIniciarEnabled ? _toggleButtons : null,
                        child: Text('Iniciar Expediente'),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20), // Space between the columns
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 50, // Fixed height for time display
                        alignment: Alignment.center,
                        child: Text(
                          encerrarTime != null ? 'Encerrado às: $encerrarTime' : '',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: isEncerrarEnabled ? _toggleButtons : null,
                        child: Text('Encerrar Expediente'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            if (workedDuration != null)
              Text(
                'Total de horas trabalhadas: ${_formatDuration(workedDuration!)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

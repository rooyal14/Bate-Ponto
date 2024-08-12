// ignore_for_file: prefer_const_constructors

import 'dart:async';

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
  Duration? dailyGoal;
  Duration? workedDuration;
  Duration? remainingTime;

  DateTime? startTime;
  DateTime? endTime;

  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _toggleButtons() {
    setState(() {
      // Toggle the button states
      isIniciarEnabled = !isIniciarEnabled;
      isEncerrarEnabled = !isEncerrarEnabled;
    });
  }


  void _handleIniciar(){
    setState(() {
      // Store the start time and display it
      startTime = DateTime.now();
      _artificialTimePassingLoop(startTime, 1);
      iniciarTime = '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
      workedDuration = Duration(hours: 0,minutes: 0);
      _toggleButtons();
    });

  }

  void _handleEncerrar(){
    setState(() {
      _toggleButtons();
    });

  }

  //Função responsável pela passagem de tempo de acordo com um ponto inicial e um multiplicador de velocidade
  void _artificialTimePassingLoop(DateTime? artificiallySelectedTime, int speedUp) {
    DateTime? now = artificiallySelectedTime;
    _timer = Timer.periodic(Duration(seconds: 2), (Timer timer) {
      now = now!.add(Duration(seconds: (2*speedUp)));
      setState(() {
        //Atualiza Total de horas trabalhadas até agora
        workedDuration = now!.difference(startTime!);
        //remainingTime = workedDuration.difference(dailyGoal!);
        remainingTime = dailyGoal!-workedDuration!;
      });


      //EncerrarClickado
      if(!isEncerrarEnabled) {
        setState(() {
          //Seta endTime para agora
          endTime = now;
          //Formata para exibição
          encerrarTime = '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';
        });
        //Mata timer
        timer.cancel();
      }
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
    setState(() {
      dailyGoal = Duration(
        hours: widget.workHours.hour,
        minutes: widget.workHours.minute,
      );
    });

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
            SizedBox(height: 10),
            Text(
              remainingTime != null ? 'Horário restante: ${_formatDuration(remainingTime!)}' : '',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.brown),
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
                        onPressed: isIniciarEnabled ? _handleIniciar : null,
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
                        onPressed: isEncerrarEnabled ? _handleEncerrar : null,
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

import 'package:flutter/material.dart';
import 'package:bate_ponto/services/local_notification_service.dart';
import 'iniciar_encerrar.dart';

class HourSelectionPage extends StatefulWidget {
  @override
  _HourSelectionPageState createState() => _HourSelectionPageState();
}

class _HourSelectionPageState extends State<HourSelectionPage> {
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 17, minute: 0);
  late final LocalNotificationService _notificationService = LocalNotificationService();

  @override
  void initState() {
    super.initState();
    _initializeNotificationService();
  }

  Future<void> _initializeNotificationService() async {
    await _notificationService.initialize();
  }

  void _showStartTimeNotification() {
    _notificationService.showNotification(
      id: 1,
      title: 'Horário de início configurado',
      body: 'Horário de início configurado para ${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
    );
  }

  void _showEndTimeNotification() {
    _notificationService.showNotification(
      id: 2,
      title: 'Horário de saída configurado',
      body: 'Horário de saída configurado para ${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
    );
  }

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
              'Início: ${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (time != null && time != _startTime) {
                  setState(() {
                    _startTime = time;
                  });
                  _showStartTimeNotification(); // Mostrar notificação ao ajustar o horário de início
                }
              },
              child: Text('Escolher Horário de Início'),
            ),
            SizedBox(height: 20),
            Text(
              'Saída: ${_endTime.hour.toString().padLeft(2, '0')}:${_endTime.minute.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: _endTime,
                  builder: (BuildContext context, Widget? child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                      child: child!,
                    );
                  },
                );

                if (time != null && time != _endTime) {
                  setState(() {
                    _endTime = time;
                  });
                  _showEndTimeNotification(); // Mostrar notificação ao ajustar o horário de saída
                }
              },
              child: Text('Escolher Horário de Saída'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExpedientePage(
                      workHours: _startTime,
                      endHours: _endTime,
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

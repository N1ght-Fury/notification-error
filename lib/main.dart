import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() {
  runApp(MyApp());

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Scheduled notifications',
        channelDescription: 'Scheduled notification channel',
        ledColor: Colors.white,
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Notification Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: TextButton(
          child: Text('Select Time'),
          onPressed: () async {
            TimeOfDay result = await showTimePicker(
              initialTime: TimeOfDay.now(),
              context: context,
              builder: (BuildContext context, Widget child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                  child: child,
                );
              },
            );

            if (result != null) {
              await AwesomeNotifications().createNotification(
                content: NotificationContent(
                  id: result.format(context).hashCode,
                  channelKey: 'scheduled',
                  title: 'Reading Reminder',
                  body: 'Test reminder',
                ),
                schedule: NotificationCalendar(
                  repeats: true,
                  hour: result.hour,
                  minute: result.minute,
                  second: 0,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

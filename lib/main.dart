import 'package:flutter/material.dart';
import 'NotificationService.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Local Notifications'),
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
  @override
  void initState() {
    super.initState();
    NotificationService.init(); //Calling the Init of the Notification service
    NotificationService
        .initializeTimeZone(); //Initializing timezone in the Notification Service
    listenNotifications();
  }

  /* Listening to the String payload emitted by the BehaviorSubject "onNotifications" in the NotificaionService. 
  And Navigate to the desired Screen */
  void listenNotifications() {
    NotificationService.onNotifications.stream.listen((payload) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: ((context) => Home(
                payload: payload,
              ))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Press any one to test Notifications",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
            ),
            OutlineButton(
              onPressed: () {
                NotificationService.showNotification(
                    title: "Simple Notification",
                    body: "Hello, This is Simple Notification",
                    payload: "notification_content");
              },
              child: const Text("Simple Notification"),
              color: Colors.grey[400],
            ),
            const SizedBox(
              height: 8,
            ),
            OutlineButton(
              onPressed: () {
                NotificationService.showScheduledNotification(
                    title: "Scheduled Notification",
                    body: "Hello, This is Scheduled Notification",
                    payload: "Scheduled Notification Content",
                    scheduleTime:
                        DateTime.now().add(const Duration(seconds: 12)));

                const snackBar = SnackBar(
                  content: Text(
                    "Notification Scheduled in next 12 secs",
                    style: TextStyle(fontSize: 18),
                  ),
                );
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(snackBar);
              },
              child: const Text("Scheduled Notification"),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  //Creating instance of the Local Notifcations
  static final _notifications = FlutterLocalNotificationsPlugin();

  //Something BehaviorSubject from rxdart package
  static final onNotifications = BehaviorSubject<String?>();

  //Notifications Details
  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        "channel name",
        channelDescription: 'channel description',
        importance: Importance.max,
      ),
    );
  }

  //Init for the Notification service
  static Future init({bool initScheduled = false}) async {

    const android = AndroidInitializationSettings(
        '@mipmap/ic_launcher'); //Important to assign a icon otherwise exception
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings,
        onSelectNotification: ((payload) async {
      onNotifications.add(payload);
    }));
  }

  //Initializing Timezones
  static Future<void> initializeTimeZone() async => tz.initializeTimeZones();

  //Show simple notification
  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(),
      payload: payload,
    );
  }

  //Show Scheduled Notification
    static Future showScheduledNotification(
      {int id = 0, String? title, String? body, String? payload,required DateTime scheduleTime}) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleTime,tz.getLocation("Asia/Kolkata")),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime
    );
  }
}

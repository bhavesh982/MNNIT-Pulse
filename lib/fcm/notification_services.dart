import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class NotificationServices{
  FirebaseMessaging messaging=FirebaseMessaging.instance;

  Future<String> getDeviceToken()async{
    String? token=await messaging.getToken();
    return token!;
  }
  void isTokenRefresh()async{
    messaging.onTokenRefresh.listen((event){
      event.toString();
    });
  }
  final FlutterLocalNotificationsPlugin _flutterNotificationPlugin=FlutterLocalNotificationsPlugin();

  void initLocalNotifications()async{
    var androidInitialization = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =InitializationSettings(
        android: androidInitialization
    );
    await _flutterNotificationPlugin.initialize(initializationSettings,
      onSelectNotification: (payload){

      }
    );
  }

  void firebaseInit(){

    FirebaseMessaging.onMessage.listen((message){
      if(kDebugMode){
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
        showNotification(message);
    });
  }
  Future<void>showNotification(RemoteMessage message)async {
    AndroidNotificationChannel channel=AndroidNotificationChannel(Random.secure().nextInt(1000000).toString(), 'High Importance Notification',
    importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails=
    AndroidNotificationDetails(
        channel.id.toString(),
       channel.name.toString(),
      channelDescription: 'Channel Description',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker'
    );
    NotificationDetails notificationDetails=NotificationDetails(
      android: androidNotificationDetails
    );
    Future.delayed(Duration.zero,(){
      _flutterNotificationPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails
      );
    });

  }
  void requestNotificationPermission()async{
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if(settings.authorizationStatus==AuthorizationStatus.authorized){
       print("PERMISSION GRANTED");
    }else if(settings.authorizationStatus==AuthorizationStatus.provisional){
       print("PROVISIONAL PERMISSION GRANTED");
    }else{
      print("PERMISSION DENIED");
    }
  }
}
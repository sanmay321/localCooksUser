import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:localcooks_app/app/services/background/local_storage_service.dart';

class FCMService extends GetxController{

  FirebaseMessaging? _firebaseMessaging;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
  static bool isNotified=false;
  LocalStorageService localStorageService = Get.find();

  @override
  void onInit() {
    _firebaseMessaging = FirebaseMessaging.instance;
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    prepareFirebaseNotifications();
    super.onInit();
  }

  Future onSelectNotification(NotificationResponse notificationResponse) async {
    debugPrint("onSelectNotification");
    var payload = notificationResponse.payload;
    //var obj = json.decode(json.encode(payload));
    //debugPrint('$obj');
  }

  prepareFirebaseNotifications() async{

    var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin!.initialize(initializationSettings, onDidReceiveNotificationResponse: onSelectNotification);


    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true,);

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      print("========= getInitialMessage() =========");

    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("========= onMessageOpenedApp =========");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("======= onMessage ===========");
      if(Platform.isIOS){
        if(!isNotified){
          isNotified = true;
          showNotification(message.notification!.title!, message.notification!.body!, message.data['push_data']);
          Future.delayed(const Duration(seconds: 1), (){
            isNotified = false;
          });
        }
      }else{
        showNotification(message.notification!.title ?? "", message.notification!.body ?? "", "");
      }
    });


    _firebaseMessaging!.requestPermission().then((value) {
      _firebaseMessaging!.getToken().then((token){
        debugPrint('Token: $token');
        saveMyToken(token.toString());
      }).catchError((e) {
        debugPrint(e.toString());
      });
    });

  }

  saveMyToken(token) async{
    await localStorageService.saveToken(token);
  }

  void showNotification(String title, String body, dynamic data) async {
    await _demoNotification(title, body, data);
  }


  Future<void> _demoNotification(String title, String body, dynamic data) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        '86523', 'Volunteers',
        channelDescription: 'volunteers_ae_app',
        importance: Importance.max,
        playSound: true,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker'
    );

    var iOSChannelSpecifics = const DarwinNotificationDetails(presentSound: true, presentAlert: true, presentBadge: true, sound: 'default');
    var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin!.show(0, title, body, platformChannelSpecifics, payload: data);
  }

}
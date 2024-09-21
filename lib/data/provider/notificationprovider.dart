import 'package:booking_haircut_application/data/model/notificationmodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ReadDataNotification {
  Future<List<Notification>> loadData() async {
    var data =
        await rootBundle.loadString("assets/files/notificationlist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['notification'] as List)
        .map((p) => Notification.fromJson(p))
        .toList();
  }
}

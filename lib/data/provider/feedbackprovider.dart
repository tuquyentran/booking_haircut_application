import 'package:booking_haircut_application/data/model/feedbackmodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ReadDataFeedback {
  Future<List<Feedback>> loadData() async {
    var data = await rootBundle.loadString("assets/files/feedbacklist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['feedback'] as List)
        .map((p) => Feedback.fromJson(p))
        .toList();
  }
}

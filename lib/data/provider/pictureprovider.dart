import 'package:booking_haircut_application/data/model/picturemodel.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class ReadDataPicture {
  Future<List<Picture>> loadData() async {
    var data = await rootBundle.loadString("assets/files/picturelist.json");
    var dataJson = jsonDecode(data);

    return (dataJson['picture'] as List)
        .map((p) => Picture.fromJson(p))
        .toList();
  }
}

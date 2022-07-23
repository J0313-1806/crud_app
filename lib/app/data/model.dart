// ignore_for_file: prefer_if_null_operators

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

List<Model> modelFromJson(String str) =>
    List<Model>.from(json.decode(str).map((x) => Model.fromJson(x)));
// List<SunTimeModel> sunTimeModelFromJson(String str) => List<SunTimeModel>.from(json.decode(str).map((x) => SunTimeModel.fromJson(x)));

class Model {
  Model({
    required this.id,
    required this.title,
    required this.desc,
    required this.image,
    required this.date,
  });
  String id;
  String title;
  String desc;
  String image;
  DateTime date;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"] == null ? '' : json["id"],
        title: json["title"] == null ? '' : json["title"],
        desc: json["desc"] == null ? '' : json["desc"],
        image: json["image"] == null ? "assets/index.jpg" : json["image"],
        date: json["date"] == null
            ? DateTime.now()
            : DateTime.fromMillisecondsSinceEpoch(
                json["date"].millisecondsSinceEpoch),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'image': image,
        'date': date,
      };
}

DateTime parseTime(Timestamp date) {
  return Platform.isIOS ? (date).toDate() : (date as DateTime);
}

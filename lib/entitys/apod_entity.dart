import 'package:flutter_nasa_app/entitys/base_entity.dart';

class ApodEntity extends BaseEntity {

  ApodEntity({ this.date,
    this.explanation,
    this.hdurl,
    this.mediaType,
    this.serviceVersion,
    this.title,
    this.url}) : super();

  String? date;
  String? explanation;
  String? hdurl;
  String? mediaType;
  String? serviceVersion;
  String? title;
  String? url;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['explanation'] = this.explanation;
    data['hdurl'] = this.hdurl;
    data['media_type'] = this.mediaType;
    data['service_version'] = this.serviceVersion;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }

  fromJson(Map<String, dynamic> json) {
    ApodEntity entity = ApodEntity();

    entity.date = json['date'];
    entity.explanation = json['explanation'];
    entity.hdurl = json['hdurl'];
    entity.mediaType = json['media_type'];
    entity.serviceVersion = json['service_version'];
    entity.title = json['title'];
    entity.url = json['url'];

    return entity;
  }
}
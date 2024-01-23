import 'package:flutter/material.dart';

class Users {
  String? id;
  String? name;
  String? lastName;
  LinearGradient? avatarGradient;
  String? email;
  String? status;

  Users({
    this.id,
    required this.name,
    required this.email,
    required this.status,
    required this.lastName,
    this.avatarGradient,
  });

  Users.fromJson(Map<String, dynamic> json) {
    id = json['uid'];
    name = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = id;
    data['first_name'] = name;
    data['last_name'] = lastName;
    data['email'] = email;
    data['status'] = status;
    return data;
  }
}

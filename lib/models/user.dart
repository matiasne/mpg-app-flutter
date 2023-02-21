import 'package:mpg_mobile/models/company.dart';
import 'package:mpg_mobile/models/subscription.dart';

class User {
  int? id;
  String email;
  String? password;
  Company? company;
  Subscription? subscription;

  User({
    required this.email,
    this.id,
    this.password,
    this.company,
    this.subscription,
  });

  
    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'company': company?.toMap(),
      'subscription': subscription?.toMap(),
    };
  }

  static User fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      password: map['password'],
      company: map['company'] != null ? Company.fromMap(map['company']) : null,
      subscription: map['subscription'] != null ? Subscription.fromMap(map['subscription']) : null,
    );
  }
}
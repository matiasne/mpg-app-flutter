
class Subscription {
  int id;
  String type;

  Subscription({
    required this.id,
    required this.type,
  });

  
    Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }

  static Subscription fromMap(Map<String, dynamic> map) {
    return Subscription(
      id: map['id'],
      type: map['type'],
    );
  }
}
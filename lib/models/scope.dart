class Scope {
  String description;

  Scope({
    required this.description
  });

    Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  static Scope fromMap(Map<String, dynamic> map) {
    return Scope(
      description: map['description'],
    );
  }
}

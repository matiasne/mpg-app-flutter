class KeyAssumption {
  String description;

  KeyAssumption({
    required this.description
  });

    Map<String, dynamic> toMap() {
    return {
      'description': description,
    };
  }

  static KeyAssumption fromMap(Map<String, dynamic> map) {
    return KeyAssumption(
      description: map['description'],
    );
  }
}
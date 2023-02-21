
  String? vRequired(String? val) {
    if (val == null || val.isEmpty) return 'Field is required';
    return null;
  }
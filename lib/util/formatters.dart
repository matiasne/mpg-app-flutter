class Formatters {
  static String toPrice(String val) {
    String cleanString = clearCommas(val);
    return cleanString.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
  }

  static String clearCommas(String val) {
    return val.replaceAll(",", "");
  }
}

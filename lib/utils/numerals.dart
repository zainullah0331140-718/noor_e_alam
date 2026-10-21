String toEastern(String input) {
  const western = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const eastern = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
  String s = input;
  for (int i = 0; i < western.length; i++) {
    s = s.replaceAll(western[i], eastern[i]);
  }
  return s;
}

String formatNum(int n, bool useEastern) {
  final s = n.toString();
  return useEastern ? toEastern(s) : s;
}

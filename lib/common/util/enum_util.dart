///
/// Created by zgm on 2021/9/22
/// Describe:
///

String? enumToString<T>(T value) {
  if (value == null) return null;
  var list = value.toString().split('.');
  if (list.length != 2) return null;
  var text = list[1];
  if (text.startsWith(r'$')) return text.substring(1);
  return text;
}

T? enumFromString<T>(List<T> values, String? text) {
  if (values.isEmpty || text == null) return null;
  for (var element in values) {
    var list = element.toString().split('.');
    if (list.length == 2 && (list[1] == text || list[1] == '\$$text')) {
      return element;
    }
  }
  return null;
}

T enumFromStringStrict<T>(List<T> values, String? text, {required T onDefault}) {
  return enumFromString(values, text) ?? onDefault;
}

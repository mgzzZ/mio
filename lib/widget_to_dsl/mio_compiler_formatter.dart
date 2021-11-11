///
/// Created by zgm on 2021/11/8
/// Describe:
///
import 'dart:convert';

class JsonFormatter {
  var encoder = JsonEncoder.withIndent('  ');

  String format(String source) {
    return encoder.convert(jsonDecode(source));
  }
}

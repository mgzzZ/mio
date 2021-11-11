import 'package:flutter/cupertino.dart';

///
/// Created by zgm on 2021/10/13
/// Describe:
///

extension WidgetExt on Widget {
  Map<String, dynamic> toMap() {
    switch (this.runtimeType.toString()) {
      case 'Text':
        Text text = this as Text;
        return {'name': 'Text'};

      default:
        return {};
    }
  }
}

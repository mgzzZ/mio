import 'package:flutter/material.dart';

///
/// Created by zgm on 2021/9/24
/// Describe:
///

extension BoxDecorationExt on BoxDecoration {
  Map<String, dynamic> toMap() {
    return {
      'name': 'BoxDecoration',
      if (this.color != null) ...{'color': this.color!.value},
      if (this.borderRadius != null) ...{
        'borderRadius': (this.borderRadius as BorderRadius).toMap()
      },
      if (this.border != null) ...{'border': this.border},
    };
  }
}

extension BorderRadiusExt on BorderRadius {
  Map<String, dynamic> toMap() {
    return {
      'name': 'BorderRadius',
      'topRight': this.topRight,
      'bottomLeft': this.bottomLeft,
      'bottomRight': this.bottomRight,
      'topLeft': this.topLeft,
    };
  }
}

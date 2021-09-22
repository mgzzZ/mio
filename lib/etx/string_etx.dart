import 'package:flutter/material.dart';

///
/// Created by zgm on 2021/9/22
/// Describe:
///

extension StringExt on String {
  FontWeight? toFontWeight() {
    switch (this) {
      case 'normal':
      case 'regular':
      case 'plain':
        return FontWeight.w400;
      case 'medium':
        return FontWeight.w500;
      case 'bold':
        return FontWeight.w600;
      default:
    }
  }
}

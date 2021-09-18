import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mio/base/m_widget.dart';

///
/// Created by zgm on 2021/9/18
/// Describe:标签 文本
///

const int localMaxLines = 5;

class MText extends MWidget {
  final String text;
  final TextStyle? style;
  final Color? textColor;
  final double? fontSize;
  final int? maxLines;
  const MText(
    this.text, {
    Key? key,
    this.style,
    this.textColor,
    this.fontSize,
    this.maxLines,
  }) : super(key: key);

  static MWidget h1(String text, {int maxLines = localMaxLines}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.headline1,
        maxLines: maxLines,
      );
    });
  }

  static MWidget h2(String text, {int maxLines = localMaxLines}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.headline2,
        maxLines: maxLines,
      );
    });
  }

  static MWidget h3(String text, {int maxLines = localMaxLines}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.headline3,
        maxLines: maxLines,
      );
    });
  }

  static MWidget body1(String text, {int maxLines = localMaxLines}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: maxLines,
      );
    });
  }

  static MWidget body2(String text, {int maxLines = localMaxLines}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.bodyText2,
        maxLines: maxLines,
      );
    });
  }

  MWidget copyWith({Color? color, double? fontSize, int? maxLines}) {
    TextStyle style = textStyle.copyWith(color: color, fontSize: fontSize);

    return MText(
      text,
      style: style,
      maxLines: maxLines,
    );
  }

  TextStyle get textStyle => style ?? TextStyle(color: textColor, fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      maxLines: maxLines,
    );
  }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    TextStyle textStyle = style ?? TextStyle(color: textColor, fontSize: fontSize);
    return {'name': 'MText', 'text': text, 'style': textStyle.toMap()};
  }
}

extension TextStyleExt on TextStyle {
  Map<String, dynamic> toMap() {
    return {
      'color': this.color!.value,
      'fontSize': this.fontSize,
    };
  }

  TextStyle formMap(Map data) {
    final value = data['color'];
    Color color = Color(value);
    return this.copyWith(color: color, fontSize: data['fontSize']);
  }
}

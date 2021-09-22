import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mio/base/m_widget.dart';
import 'package:mio/etx/map_etx.dart';
import 'package:mio/etx/string_etx.dart';
import 'package:mio/util/enum_util.dart';

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
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  const MText(
    this.text, {
    Key? key,
    this.style,
    this.textColor,
    this.fontSize,
    this.maxLines,
    this.fontWeight,
    this.fontFamily,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  static MWidget h1(String text,
      {int maxLines = localMaxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context)
            .textTheme
            .headline1!
            .copyWith(fontFamily: fontFamily, fontWeight: fontWeight),
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    });
  }

  static MWidget h2(String text,
      {int maxLines = localMaxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.headline2,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    });
  }

  static MWidget h3(String text,
      {int maxLines = localMaxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.headline3,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    });
  }

  static MWidget body1(String text,
      {int maxLines = localMaxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.bodyText1,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    });
  }

  static MWidget body2(String text,
      {int maxLines = localMaxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    return MBuilder(builder: (context) {
      return MText(
        text,
        style: Theme.of(context).textTheme.bodyText2,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    });
  }

  MWidget copyWith(
      {Color? color,
      double? fontSize,
      int? maxLines,
      FontWeight? fontWeight,
      String? fontFamily,
      TextAlign? textAlign,
      TextOverflow? overflow}) {
    TextStyle style = textStyle.copyWith(
        color: color, fontSize: fontSize, fontWeight: fontWeight, fontFamily: fontFamily);

    return MText(
      text,
      style: style,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  TextStyle get textStyle => style ?? TextStyle(color: textColor, fontSize: fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textStyle,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
    );
  }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    TextStyle textStyle = style ??
        TextStyle(
            color: textColor, fontSize: fontSize, fontFamily: fontFamily, fontWeight: fontWeight);
    return {
      'name': 'MText',
      'text': text,
      'style': textStyle.toMap(),
      'overflow': enumToString<TextOverflow>(overflow ?? TextOverflow.ellipsis),
      'textAlign': enumToString<TextAlign>(textAlign ?? TextAlign.left)
    };
  }
}

extension TextStyleExt on TextStyle {
  Map<String, dynamic> toMap() {
    return {
      'color': (this.color ?? Colors.black).value,
      'fontSize': this.fontSize ?? 12.0,
      'fontWeight': (this.fontWeight ?? FontWeight.w400).fontWeightToString(),
      'fontFamily': fontFamily
    };
  }

  TextStyle formMap(Map data) {
    late double? fontSize = 12.0;
    late Color? color = Colors.black;
    late String? fontFamily = '';
    late FontWeight? fontWeight = FontWeight.w400;

    if (data.safeContains('fontSize')) {
      fontSize = data['fontSize'];
    }

    if (data.safeContains('color')) {
      final value = data['color'];
      color = Color(value);
    }

    if (data.safeContains('fontFamily')) {
      fontFamily = data['fontFamily'];
    }

    if (data.safeContains('fontWeight')) {
      String value = data['fontWeight'];
      fontWeight = value.toFontWeight();
    }

    return this
        .copyWith(color: color, fontSize: fontSize, fontFamily: fontFamily, fontWeight: fontWeight);
  }
}

extension FontWeightEtx on FontWeight {
  String fontWeightToString() {
    switch (this) {
      case FontWeight.w400:
        return 'regular';
      case FontWeight.w500:
        return 'medium';
      case FontWeight.w600:
        return 'bold';
      default:
        return 'regular';
    }
  }
}

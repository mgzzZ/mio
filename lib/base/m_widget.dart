import 'package:flutter/material.dart';
import 'package:mio/etx/map_etx.dart';
import 'package:mio/util/enum_util.dart';
import 'package:mio/widgets/m_text.dart';

///
/// Created by zgm on 2021/9/18
/// Describe:
///

mixin FormatWidget {
  @protected
  Map<String, dynamic> toMap();

  // @protected
  // Widget formMap(Map<String, dynamic> data);
}

abstract class MWidget extends StatelessWidget with FormatWidget {
  const MWidget({Key? key}) : super(key: key);
  @protected
  Widget build(BuildContext context);

  @protected
  Map<String, dynamic> toMap({BuildContext? context});
}

class MContainer extends MWidget {
  final MWidget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? width;
  final double? height;
  final Decoration? decoration;
  final BoxConstraints? constraints;
  MContainer({
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
    this.decoration,
    this.constraints,
  });

  // @override
  // MWidget formMap(Map data) {
  //   return MStatelessWidget();
  // }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    return {
      'name': 'MContainer',
      if (child != null) ...{'child': child!.toMap(context: context)},
      if (color != null) ...{'color': color!.value},
      if (width != null) ...{'width': width},
      if (height != null) ...{'height': height},
      if (margin != null) ...{'margin': margin},
      if (padding != null) ...{'padding': padding},
      if (decoration != null) ...{'decoration': decoration},
      if (constraints != null) ...{'constraints': constraints},
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      padding: padding,
      margin: margin,
      height: height,
      width: width,
      constraints: constraints,
      decoration: decoration,
    );
  }
}

class MDynamicDWidget extends MWidget {
  final Map<String, dynamic> data;

  MDynamicDWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    Widget child = parse(data);
    return child;
  }

  List<Widget> parseChildren(Map<String, dynamic> data) {
    List<Map<String, dynamic>> sub = data['children'];
    List<Widget> list = [];
    list = sub.map((e) => parse(e)).toList();
    return list;
  }

  Widget parseChild(Map<String, dynamic> data) {
    return parse(data['child']);
  }

  Widget parse(Map<String, dynamic> data) {
    // if (!data.safeContains('child') && !data.safeContains('children')) {
    //   return Container();
    // }
    if (data.safeContains('child')) {
      return parseChild(data['child']);
    }

    switch (data['name']) {
      case 'MText':
        return MText(
          data['text'],
          style: TextStyle().formMap(data['style']),
          maxLines: data['maxLines'],
          overflow: enumFromString<TextOverflow>(TextOverflow.values, data['overflow']),
        );
      default:
    }
    return Container();
  }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    return {
      'name': 'MDynamicDWidget',
      'child': data,
    };
  }
}

typedef MWidgetBuilder = MWidget Function(BuildContext context);

class MBuilder extends MWidget {
  const MBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  final MWidgetBuilder builder;

  @override
  MWidget build(BuildContext context) => builder(context);

  // @override
  // MWidget formMap(Map data) {
  //   return MStatelessWidget();
  // }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    return {
      'name': 'MBuilder',
      'child': build(context!).toMap(),
    };
  }
}

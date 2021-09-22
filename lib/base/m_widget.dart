import 'package:flutter/material.dart';
import 'package:mio/etx/map_etx.dart';
import 'package:mio/util/enum_util.dart';
import 'package:mio/widgets/m_text.dart';

///
/// Created by zgm on 2021/9/18
/// Describe:
///

abstract class FormatWidget {
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

class MStatelessWidget extends MWidget {
  // @override
  // MWidget formMap(Map data) {
  //   return MStatelessWidget();
  // }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    return {'name': 'MStatelessWidget'};
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class MDynamicDWidget extends MWidget {
  final Map<String, dynamic> data;

  MDynamicDWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    Widget child = initData(data);
    return child;
  }

  Widget initData(Map<String, dynamic> data) {
    // if (!data.safeContains('child') && !data.safeContains('children')) {
    //   return Container();
    // }
    if (data.safeContains('child')) {
      return MDynamicDWidget(data: data['child']);
    }

    // if (data.safeContains('children')) {
    //   //TODO: 多个未处理
    //   Map<String, dynamic> sub = data['children'];
    //   List<Widget> list = [];
    //   sub.forEach((key, value) {
    //     list.add(initData({key: value}));
    //   });
    //
    //   return list;
    // }

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

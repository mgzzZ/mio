import 'package:flutter/material.dart';

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

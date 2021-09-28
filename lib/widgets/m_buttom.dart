import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:mio/base/m_widget.dart';
import 'package:mio/widgets/m_text.dart';

///
/// Created by zgm on 2021/9/24
/// Describe:
///

class MButton extends MWidget {
  final MWidget child;
  final Function? onTap;
  MButton({required this.child, this.onTap});

  static MWidget primary(String text, {Function? onTap}) {
    return MBuilder(builder: (context) {
      //TODO:主按钮颜色以及主按钮文字颜色
      Color bgColor = Theme.of(context).buttonTheme.colorScheme!.primary;
      Color textColor = Theme.of(context).textTheme.button?.color ?? Colors.black;
      return MButton(
        child: MContainer(
          color: bgColor,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: MText(
            text,
            textColor: textColor,
          ),
        ),
        onTap: onTap,
      );
    });
  }

  static MWidget secondary(String text, {Function? onTap}) {
    return MBuilder(builder: (context) {
      //TODO:次要颜色以及主按钮文字颜色
      Color bgColor = Theme.of(context).buttonTheme.colorScheme!.secondary;
      Color textColor = Theme.of(context).textTheme.button?.color ?? Colors.black;
      return MButton(
        child: MContainer(
          color: bgColor,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: MText(
            text,
            textColor: textColor,
          ),
        ),
        onTap: onTap,
      );
    });
  }

  static MWidget normal(String text, {Function? onTap}) {
    return MBuilder(builder: (context) {
      //TODO:次要颜色以及主按钮文字颜色
      Color bgColor = Theme.of(context).buttonTheme.colorScheme!.secondary;
      Color textColor = Theme.of(context).textTheme.button?.color ?? Colors.black;
      return MButton(
        child: MContainer(
          color: bgColor,
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: MText(
            text,
            textColor: textColor,
          ),
        ),
        onTap: onTap,
      );
    });
  }

  //TODO: IconButton

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: child,
    );
  }

  @override
  Map<String, dynamic> toMap({BuildContext? context}) {
    return {
      'name': 'MButton',
      'child': child.toMap(),
    };
  }
}

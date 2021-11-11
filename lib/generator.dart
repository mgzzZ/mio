import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:mio/m_dynamic.dart';
import 'package:mio/tpl.dart';
import 'package:source_gen/source_gen.dart';

///
/// Created by zgm on 2021/10/9
/// Describe:
///

class MDynamicGenerator extends GeneratorForAnnotation<MDynamic> {
  @override
  generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    return tpl;
  }
}

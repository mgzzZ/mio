/*
 * Copyright (C) 2005-present, 58.com.  All rights reserved.
 * Use of this source code is governed by a BSD type license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:mio/widget_to_dsl/mio_logic_unit.dart';

import 'mio_ast_node.dart';

const String kFairWellAnnotaion = 'MioWell';

//解析用到的上下文
class MioDslContext {
  //标明是变量的注解
  Map variableAnnotation;

  //标明是函数的注解
  Map methodAnnotation;

  MioDslContext(this.variableAnnotation, this.methodAnnotation);

  static MioDslContext empty() {
    return MioDslContext({}, {});
  }
}

String fairDsl(Map rootAst) {
  var mioDslContext = _prepareVariableAnnotation(rootAst);
  var proxy = _genProxy(rootAst, mioDslContext);
  stdout.writeln('################gen_proxy_begin######################');
  stdout.writeln(proxy);
  stdout.writeln('################gen_proxy_end######################');
  var map = _parseRootAst(rootAst, mioDslContext);
  var encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(map);
}

MioDslContext? _prepareVariableAnnotation(Map rootAst) {
  var annotationMap = {};
  var methodAnnotationMap = {};
  var rootExpression = Expression.fromAst(rootAst);
  if (!rootExpression.isProgram) {
    return null;
  }
  var bodyList = rootExpression.asProgram.body;
  if ((bodyList.length) == 0) {
    return null;
  }
  for (var body in bodyList) {
    if (body.isClassDeclaration) {
      var classBodyList = body.asClassDeclaration.body;
      for (var bodyNode in classBodyList) {
        //只处理变量声明
        var annotaions = [];
        if (bodyNode.isVariableDeclarationList) {
          annotaions = bodyNode.asVariableDeclarationList.annotationList;
        } else if (bodyNode.isMethodDeclaration) {
          annotaions = bodyNode.asMethodDeclaration.annotationList;
        }
        for (var annotation in annotaions) {
          if (annotation.name == kFairWellAnnotaion) {
            var arg = annotation.argumentList.first.asStringLiteral;
            if (bodyNode.isVariableDeclarationList) {
              annotationMap.putIfAbsent(arg.value, () => bodyNode.asVariableDeclarationList);
            } else if (bodyNode.isMethodDeclaration) {
              methodAnnotationMap.putIfAbsent(arg.value, () => bodyNode.asMethodDeclaration);
            }
          }
        }
      }
    }
  }
  return MioDslContext(annotationMap, methodAnnotationMap);
}

String? _genProxy(Map rootAst, MioDslContext? mioDslContext) {
  var imports = '''
  import 'package:fair/fair.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  ''';
  String className = '';
  var rootExpression = Expression.fromAst(rootAst);
  if (!rootExpression.isProgram) {
    return null;
  }
  var bodyList = rootExpression.asProgram.body;
  if ((bodyList.length) == 0) {
    return null;
  }

  //获取类名
  for (var body in bodyList) {
    if (body.isClassDeclaration) {
      if (body.asClassDeclaration.superClause == 'StatefulWidget' ||
          body.asClassDeclaration.superClause == 'StatelessWidget') {
        className = '\$' + body.asClassDeclaration.name + 'Proxy';
        break;
      }
    }
  }

  var func = '';
  var property = '';
  var component = '';
  var variableAnnotation = '';
  var methodAno = '';
  mioDslContext?.variableAnnotation.forEach((key, value) {
    if (value is VariableDeclarationList) {
      variableAnnotation += value.sourceCode + '\n';
      property +=
          '''pros['${value.declarationList.first.name}'] =() => ${value.declarationList.first.name};\n''';
    }
  });

  mioDslContext?.methodAnnotation.forEach((key, value) {
    if (value is MethodDeclaration) {
      if (value.returnType.name == 'void') {
        func += ''' functions['${value.name}'] = ${value.name};\n''';
      } else if (value.returnType.name == 'Widget') {
        component += '''plugins['${value.name}'] = (props) => ${value.name};\n ''';
      } else {
        property += '''pros['${value.name}'] = ${value.name};\n''';
      }
      methodAno += value.source;
    }
  });

  var classBody = '''
     class $className  extends FairStateProxy {
     $variableAnnotation
      @override
    Map<String, FairWidgetBuilder> component() {
        var plugins = super.component() ?? <String, FairWidgetBuilder>{};
        $component
        return plugins;
    }
    
      @override
     Map<String, FairBlocBuilder> property() {
        var pros = super.property();
        $property
        return pros;
    }
    
    @override
     Map<String, dynamic> func() {
      var functions = super.func();
       $func
      return functions;
    }
    $methodAno
  }
  ''';
  return imports + classBody;
}

// ignore: missing_return
Map? _parseRootAst(Map rootAst, MioDslContext? mioDslContext) {
  var rootExpression = Expression.fromAst(rootAst);
  if (!rootExpression.isProgram) {
    return null;
  }
  var bodyList = rootExpression.asProgram.body;
  if ((bodyList.length) == 0) {
    return null;
  }

  var tmpMap = {};
  var methods = {};

  for (var body in bodyList) {
    if (body.isClassDeclaration) {
      var classBodyList = body.asClassDeclaration.body;
      for (var bodyNode in classBodyList) {
        //只处理build函数
        if (bodyNode.isMethodDeclaration) {
          // if(bodyNode.isMethodDeclaration && bodyNode.asMethodDeclaration.name == 'build'){
          var buildBodyReturn = bodyNode.asMethodDeclaration.body.body;
          if (buildBodyReturn.isNotEmpty && buildBodyReturn.last.isReturnStatement) {
            //解析build中widgetExpression
            if (bodyNode.asMethodDeclaration.name == 'build') {
              tmpMap = _buildWidgetDsl(buildBodyReturn.last.asReturnStatement.argument,
                  mioDslContext ?? MioDslContext.empty());
            } else if (buildBodyReturn.last.asReturnStatement.argument.isMethodInvocation) {
              //混编逻辑处理
              var methodMap = {
                bodyNode.asMethodDeclaration.name: _buildWidgetDsl(
                    buildBodyReturn.last.asReturnStatement.argument,
                    mioDslContext ?? MioDslContext.empty())
              };
              methods.addAll(methodMap);
            }
          }
        } else if (body.isFunctionDeclaration) {
          var functionDeclaration = body.asFunctionDeclaration;
          var buildBodyReturn = functionDeclaration.expression.body.body;
          var methodMap = {
            functionDeclaration.name: _buildWidgetDsl(
                buildBodyReturn.last.asReturnStatement.argument,
                mioDslContext ?? MioDslContext.empty())
          };
          // methodList.add(methodMap);
          methods.addAll(methodMap);
        }
      }
    }
  }
  tmpMap.putIfAbsent('methodMap', () => methods);
  return tmpMap;
}

dynamic _buildWidgetDsl(Expression widgetExpression, MioDslContext mioDslContext) {
  var dslMap = {};
  var paMap = [];
  var naMap = {};

  var methodInvocationExpression = widgetExpression.asMethodInvocation;
  //普通类
  if (methodInvocationExpression.callee.isIdentifier) {
    //注册的方法不再使用className
    if (mioDslContext.methodAnnotation
        .containsKey(methodInvocationExpression.callee.asIdentifier.name)) {
      return "\$(${methodInvocationExpression.callee.asIdentifier.name})";
    } else if (mioDslContext.variableAnnotation
        .containsKey(methodInvocationExpression.callee.asIdentifier.name)) {
      return "%(${methodInvocationExpression.callee.asIdentifier.name})";
    }

    if (RegExp(r'^[a-z_]').hasMatch(methodInvocationExpression.callee.asIdentifier.name)) {
      return "%(${methodInvocationExpression.callee.asIdentifier.name})";
    } else {
      dslMap.putIfAbsent('className', () => methodInvocationExpression.callee.asIdentifier.name);
    }
  } else if (methodInvocationExpression.callee.isMemberExpression) {
    //方法类

    var memberExpression = methodInvocationExpression.callee.asMemberExpression;
    dslMap.putIfAbsent('className',
        () => memberExpression.object.asIdentifier.name + '.' + memberExpression.property);
  } else {
    return null;
  }

  //1.pa
  for (var arg in methodInvocationExpression.argumentList) {
    if (arg.isNamedExpression) {
      break;
    }
    //pa 常量处理
    var valueExpression = arg;
    valueExpression.isFuncParam = true;
    var paValue = _buildValueExpression(valueExpression, mioDslContext);
    paMap.add(paValue);
  }

  //2.na
  for (var arg in methodInvocationExpression.argumentList) {
    if (arg.isNamedExpression) {
      var nameExpression = arg.asNamedExpression;
      var valueExpression = nameExpression.expression;
      var naValue = _buildValueExpression(valueExpression, mioDslContext);
      naMap.putIfAbsent(nameExpression.label, () => naValue);
    }
  }

  if (paMap.isNotEmpty) {
    dslMap.putIfAbsent('pa', () => paMap);
  }

  if (naMap.isNotEmpty) {
    dslMap.putIfAbsent('na', () => naMap);
  }

  return dslMap;
}

dynamic _buildValueExpression(Expression valueExpression, MioDslContext mioDslContext) {
  var naPaValue;

  if (valueExpression.isIdentifier) {
    //映射变量声明
    if (mioDslContext.variableAnnotation.containsKey(valueExpression.asIdentifier.name) ||
        mioDslContext.methodAnnotation.containsKey(valueExpression.asIdentifier.name)) {
      naPaValue = '#(' + valueExpression.asIdentifier.name + ')';
    }
    // else if (mioDslContext.variables
    //     .containsKey(valueExpression.asIdentifier.name)) {
    //   naPaValue = '\$(' + valueExpression.asIdentifier.name + ')';
    // }
    else if (MioLogicUnit().functions.containsKey(valueExpression.asIdentifier.name)) {
      naPaValue = '@(' + valueExpression.asIdentifier.name + ')';
    } else {
      naPaValue = '^(' + valueExpression.asIdentifier.name + ')';
    }
  } else if (valueExpression.isNumericLiteral) {
    naPaValue = valueExpression.asNumericLiteral.value;
  } else if (valueExpression.isStringLiteral) {
    naPaValue = valueExpression.asStringLiteral.value;
  } else if (valueExpression.isBooleanLiteral) {
    naPaValue = valueExpression.asBooleanLiteral.value;
  } else if (valueExpression.isPrefixedIdentifier) {
    if (RegExp(r'^[a-z_]') // widget.** 参数类的特殊处理成#(),兼容1期
            .hasMatch(valueExpression.asPrefixedIdentifier.prefix) &&
        ('widget' != valueExpression.asPrefixedIdentifier.prefix)) {
      naPaValue = '\$(' +
          valueExpression.asPrefixedIdentifier.prefix +
          '.' +
          valueExpression.asPrefixedIdentifier.identifier +
          ')';
    } else {
      naPaValue = '#(' +
          valueExpression.asPrefixedIdentifier.prefix +
          '.' +
          valueExpression.asPrefixedIdentifier.identifier +
          ')';
    }
  } else if (valueExpression.isPropertyAccess) {
    if (valueExpression.asPropertyAccess.expression.isPrefixedIdentifier) {
      var prefixedIdentifier = valueExpression.asPropertyAccess.expression.asPrefixedIdentifier;
      naPaValue = '\$(${prefixedIdentifier.prefix}' +
          '.' +
          '${prefixedIdentifier.identifier}' +
          '.' +
          '${valueExpression.asPropertyAccess.name})';
    } else {
      naPaValue = '';
    }
  } else if (valueExpression.isMapLiteral) {
    var retMap = <String, dynamic>{};
    valueExpression.asMapLiteral.elements.forEach((key, value) {
      retMap.putIfAbsent(key, () => _buildValueExpression(value, mioDslContext));
    });
    naPaValue = retMap;
  } else if (valueExpression.isListLiteral) {
    var widgetExpressionList = [];
    for (var itemWidgetExpression in valueExpression.asListLiteral.elements) {
      widgetExpressionList.add(_buildValueExpression(itemWidgetExpression, mioDslContext));
    }
    naPaValue = widgetExpressionList;
  } else if (valueExpression.isFunctionExpression) {
    naPaValue = '';
    if (valueExpression.asFunctionExpression.body.body.isNotEmpty) {
      naPaValue =
          _buildValueExpression(valueExpression.asFunctionExpression.body.body.last, mioDslContext);
    }
  } else if (valueExpression.isReturnStatement) {
    naPaValue = _buildValueExpression(valueExpression.asReturnStatement.argument, mioDslContext);
  } else if (valueExpression.isStringInterpolation) {
    var sourceString = valueExpression.asStringInterpolation.sourceString;
    if (sourceString.length >= 2) {
      if (sourceString.startsWith('\'') && sourceString.endsWith('\'') ||
          sourceString.startsWith('\"') && sourceString.endsWith('\"')) {
        sourceString = sourceString.substring(1, sourceString.length - 1);
      }
    }
    naPaValue = '#(' + sourceString + ')';
  } else if (valueExpression.isVariableExpression) {
    var expression = valueExpression.asVariableExpression.expression;
    naPaValue = '\$(' + expression + ')';
  } else {
    naPaValue = _buildWidgetDsl(valueExpression, mioDslContext);
  }
  return naPaValue;
}

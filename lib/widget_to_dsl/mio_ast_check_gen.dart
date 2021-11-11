/*
 * Copyright (C) 2005-present, 58.com.  All rights reserved.
 * Use of this source code is governed by a BSD type license that can be
 * found in the LICENSE file.
 */

import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'mio_ast_gen.dart';
import 'mio_ast_node.dart';

class AstNodeCheck {
  final StringPathName;
  const AstNodeCheck(this.StringPathName);
}

class AstNodeMapGenerator extends GeneratorForAnnotation<AstNodeCheck> {
  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    var checkNodeMapFile = File('lib/widget_to_dsl/mio_check_node_map.dart');
    var filepath = File('lib/widget_to_dsl/mio_ast_gen.dart').absolute.path;
    var rootAst = await generateAstMap(filepath);
    var rootExpression = Expression.fromAst(rootAst);

    var supportNode = {
      'DeclaredSimpleIdentifier': 'DeclaredSimpleIdentifier',
      'ConstructorDeclarationImpl': 'ConstructorDeclarationImpl',
      'InterpolationStringImpl': 'InterpolationStringImpl',
    };
    if (!rootExpression.isProgram) {
      return null;
    }
    var bodyList = rootExpression.asProgram.body;
    if ((bodyList.length) == 0) {
      return null;
    }
    for (var body in bodyList) {
      if (body.isClassDeclaration && body.asClassDeclaration.name == 'MyAstVisitor') {
        if ((body.asClassDeclaration.body.length) > 0) {
          for (var visitDeclaration in body.asClassDeclaration.body) {
            if (visitDeclaration.isMethodDeclaration &&
                visitDeclaration.asMethodDeclaration.name.startsWith('visit')) {
              var parameters = visitDeclaration.asMethodDeclaration.parameterList;
              if (parameters.isNotEmpty) {
                var nodeName = parameters.first.paramType.name;
                supportNode.putIfAbsent(
                    nodeName + 'Impl', () => visitDeclaration.asMethodDeclaration.name);
              }
            }
          }
        }
      }
    }

    final explanation =
        '// **************************************************************************\n'
        '// 如果存在新文件需要更新，建议先执行清除命令：\n'
        '// flutter packages pub run build_runner clean \n'
        '// \n'
        '// 然后执行下列命令重新生成相应文件：\n'
        '// flutter packages pub run build_runner build --delete-conflicting-outputs \n'
        '// 自动生成请勿修改\n'
        '// **************************************************************************';
    var encoder = JsonEncoder.withIndent('  ');
    var content = explanation + '\nfinal checkNode=' + encoder.convert(supportNode) + ';';
    await checkNodeMapFile.writeAsString(content);
  }
}

Builder AstNodeMapBuilder(BuilderOptions options) => LibraryBuilder(AstNodeMapGenerator());

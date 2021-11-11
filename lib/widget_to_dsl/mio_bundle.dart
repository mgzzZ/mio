import 'package:mio/widget_to_dsl/mio_ast_gen.dart';
import 'package:mio/widget_to_dsl/mio_dsl_gen.dart';

///
/// Created by zgm on 2021/11/8
/// Describe:
///

Future<String> parseFile(String filePath) async {
  var ast = await generateAstMap(filePath);
  return fairDsl(ast);
}

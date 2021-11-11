///
/// Created by zgm on 2021/11/8
/// Describe:
///
import 'package:build/build.dart';
import 'package:mio/widget_to_dsl/mio_compiler_bundle_builder.dart';
import 'package:mio/widget_to_dsl/mio_compiler_formatter.dart';
import 'package:mio/widget_to_dsl/mio_compiler_generator.dart';
import 'package:mio/widget_to_dsl/mio_compiler_poster_builder.dart';

Builder build(BuilderOptions options) {
  return BundleBuilder(BundleGenerator(), formatOutput: JsonFormatter().format);
}

Builder bind(BuilderOptions options) {
  return BundleBuilder(BindingGenerator(),
      generatedExtension: '.mio.ignore', formatOutput: (_) => _);
}

Builder package(BuilderOptions options) {
  return PackageBuilder();
}

PostProcessBuilder archive(BuilderOptions options) {
  return ArchiveBuilder();
}

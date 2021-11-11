///
/// Created by zgm on 2021/10/9
/// Describe:
///

library mio.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'generator.dart';

Builder mDynamicBuilder(BuilderOptions options) =>
    LibraryBuilder(MDynamicGenerator(), generatedExtension: '.m.dart');

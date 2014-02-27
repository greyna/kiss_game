library vmtest;

import 'package:unittest/unittest.dart';
import 'dart:io';

part 'main_vmtest.dart';


main() {
  Process.run('content_shell', ['--dump-render-tree', 'main_webtest.html'])
    .then((ProcessResult process) => print(process.stdout));
  //mainTest();
}

const Map<String,Function> tests = const {'mainTest': mainTest};

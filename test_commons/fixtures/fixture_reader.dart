import 'dart:io';

String fixture(String name) =>
    File('test_commons/fixtures/$name').readAsStringSync();

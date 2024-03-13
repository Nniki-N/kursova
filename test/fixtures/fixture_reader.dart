import 'dart:io';

String fixture({required String fileName}) {
  return File('test/fixtures/$fileName').readAsStringSync();
}

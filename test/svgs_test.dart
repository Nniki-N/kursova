import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/resources/graphics/resources.dart';

void main() {
  test('svgs assets test', () {
    expect(File(Svgs.addIcon).existsSync(), isTrue);
    expect(File(Svgs.closeIcon).existsSync(), isTrue);
    expect(File(Svgs.infoIcon).existsSync(), isTrue);
    expect(File(Svgs.locationIcon).existsSync(), isTrue);
    expect(File(Svgs.markerIcon).existsSync(), isTrue);
    expect(File(Svgs.menuIcon).existsSync(), isTrue);
    expect(File(Svgs.smallArrowLeftIcon).existsSync(), isTrue);
  });
}

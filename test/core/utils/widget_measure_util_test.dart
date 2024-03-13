import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kursova/core/utils/widget_measure_util.dart';

void main() {
  group(
    'WidgetMeasureUtil ->',
    () {
      late Widget widget;
      late Size widgetSize;

      setUp(() {
        widgetSize = const Size(100, 100);
        widget = SizedBox(
          width: widgetSize.width,
          height: widgetSize.height,
        );
      });

      group(
        'measureWidget function',
        () {
          test(
            'should return size of provided widget',
            () {
              final size = WidgetMeasureUtil.measureWidget(widget);

              expect(size.width, widgetSize.width);
              expect(size.height, widgetSize.height);
            },
          );
        },
      );
    },
  );
}

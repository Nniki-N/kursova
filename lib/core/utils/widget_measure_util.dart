// ignore_for_file: prefer_asserts_with_message

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// An util to measure a widget before actually putting it on screen.
///
/// This can be helpful e.g. for positioning context menus based on the size they will take up.
abstract class WidgetMeasureUtil {

  /// Measures size of provided [widget].
  static Size measureWidget(Widget widget) {
    final PipelineOwner pipelineOwner = PipelineOwner();
    final _MeasurementView rootView =
        pipelineOwner.rootNode = _MeasurementView(const BoxConstraints());
    final BuildOwner buildOwner = BuildOwner(focusManager: FocusManager());
    final RenderObjectToWidgetElement<RenderBox> element =
        RenderObjectToWidgetAdapter<RenderBox>(
      container: rootView,
      debugShortDescription: '[root]',
      child: widget,
    ).attachToRenderTree(buildOwner);
    try {
      rootView.scheduleInitialLayout();
      pipelineOwner.flushLayout();
      return rootView.size;
    } finally {
      // Cleans up
      element.update(
        RenderObjectToWidgetAdapter<RenderBox>(container: rootView),
      );

      buildOwner.finalizeTree();
    }
  }
}

class _MeasurementView extends RenderBox
    with RenderObjectWithChildMixin<RenderBox> {
  final BoxConstraints boxConstraints;
  _MeasurementView(this.boxConstraints);

  @override
  void performLayout() {
    assert(child != null);
    child!.layout(boxConstraints, parentUsesSize: true);
    size = child!.size;
  }

  @override
  void debugAssertDoesMeetConstraints() => true;
}

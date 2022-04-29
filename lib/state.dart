import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'simple_candlestick_chart.dart';

class ChartState extends GetxController {
  late final SimpleCandlestickChart widget;
  final data = <CandlestickData>[].obs;
  final scrollView = ScrollController();
  final itemWidth = 12.0.obs;
  final high = 0.0.obs;
  final low = double.infinity.obs;
  final maxVolume = 0.0.obs;
  final start = 0.obs;
  final end = 0.obs;
  var maxWidth = 0.0;
  var scale = 0.0;
  var previousItemWidth = 0.0;
  var previousOffset = 0.0;

  void updateOffset(double offset) {
    final start = offset ~/ itemWidth.value;
    final end = ((offset + maxWidth) / itemWidth.value).ceil();

    if (this.start.value == start && this.end.value == end) return;

    this.start.value = start;
    this.end.value = end;

    var high = 0.0;
    var low = double.infinity;
    var maxVolume = 0.0;
    for (var i = start; i < end; i += 1) {
      final item = data[i];
      if (item.high > high) high = item.high;
      if (item.low < low) low = item.low;
      if (item.volume > maxVolume) maxVolume = item.volume;
    }
    this.high.value = high;
    this.low.value = low;
    this.maxVolume.value = maxVolume;
  }

  void onScaleStart(ScaleStartDetails event) {
    previousItemWidth = itemWidth.value;
    previousOffset = scrollView.offset;
    scale = 0;
  }

  void onScaleUpdate(ScaleUpdateDetails event) {
    var scale = event.scale;
    if (this.scale == 0) {
      this.scale = scale;
      return;
    }
    scale /= this.scale;
    var itemWidth = previousItemWidth * scale;
    itemWidth = max(min(itemWidth, widget.maxItemWidth), widget.minItemWidth);
    scale = itemWidth / previousItemWidth;
    this.itemWidth.value = itemWidth;
    final offset =
        min(previousOffset * scale, data.length * itemWidth - maxWidth - 1e-2);
    scrollView.jumpTo(offset);
  }
}

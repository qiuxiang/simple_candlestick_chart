import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'candlestick_data.dart';
import 'item.dart';
import 'state.dart';

export 'candlestick_data.dart';

/// A Simple candlestick chart. Supports smooth scroll and zoom.
class SimpleCandlestickChart extends StatefulWidget {
  /// The candlestick data list. newest data on the first.
  final List<CandlestickData> data;

  /// Animation curve
  final Curve curve;

  /// Animation duration
  final Duration transition;

  /// Height of the volume chart
  final double volumeHeight;

  final Color increaseColor;
  final Color decreaseColor;
  final double maxItemWidth;
  final double minItemWidth;

  /// Scroll physics
  final ScrollPhysics? physics;

  const SimpleCandlestickChart({
    Key? key,
    required this.data,
    this.increaseColor = Colors.green,
    this.decreaseColor = Colors.red,
    this.maxItemWidth = 20,
    this.minItemWidth = 4,
    this.curve = Curves.easeOutCubic,
    this.transition = const Duration(milliseconds: 300),
    this.volumeHeight = 60,
    this.physics,
  }) : super(key: key);

  @override
  State<SimpleCandlestickChart> createState() => _SimpleCandlestickChartState();
}

class _SimpleCandlestickChartState extends State<SimpleCandlestickChart> {
  late final ChartState state;

  @override
  void initState() {
    super.initState();
    state = ChartState();
    state.widget = widget;
    Get.put(state);
  }

  @override
  void didUpdateWidget(covariant SimpleCandlestickChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      state.data.assignAll(widget.data);
      state.updateOffset(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      state.maxWidth = constraints.maxWidth;
      return GestureDetector(
        onScaleStart: state.onScaleStart,
        onScaleUpdate: state.onScaleUpdate,
        child: NotificationListener(
          onNotification: (event) {
            if (event is ScrollUpdateNotification) {
              state.updateOffset(event.metrics.pixels);
            }
            return true;
          },
          child: CustomScrollView(
            controller: state.scrollView,
            scrollDirection: Axis.horizontal,
            physics: widget.physics,
            reverse: true,
            slivers: [
              Obx(() {
                return SliverFixedExtentList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Item(index),
                    childCount: state.data.length,
                  ),
                  itemExtent: state.itemWidth.value,
                );
              }),
            ],
          ),
        ),
      );
    });
  }
}

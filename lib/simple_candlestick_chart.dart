import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'candlestick_data.dart';
import 'item.dart';
import 'state.dart';

export 'candlestick_data.dart';

class SimpleCandlestickChart extends StatefulWidget {
  final List<CandlestickData> data;
  final Color increaseColor;
  final Color decreaseColor;
  final Curve curve;
  final Duration transition;
  final double volumeHeight;
  final double maxItemWidth;
  final double minItemWidth;

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

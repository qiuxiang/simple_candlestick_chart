import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'state.dart';

class Item extends StatelessWidget {
  final int index;
  Item(this.index, {Key? key}) : super(key: key);

  final state = Get.find<ChartState>();

  @override
  Widget build(BuildContext context) {
    final item = state.data[index];
    final changes = item.close - item.open;
    final color =
        changes > 0 ? state.widget.increaseColor : state.widget.decreaseColor;
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(children: [
        Expanded(
          child: ItemBuilder(index, (height) {
            final ratio = (state.high.value - state.low.value) / height;
            final bottom = min(item.open, item.close) - state.low.value;
            return Stack(alignment: Alignment.bottomCenter, children: [
              AnimatedContainer(
                curve: state.widget.curve,
                duration: state.widget.transition,
                margin: EdgeInsets.only(
                  bottom: (item.low - state.low.value) / ratio,
                ),
                width: 1,
                height: (item.high - item.low) / ratio,
                color: color,
              ),
              AnimatedContainer(
                curve: state.widget.curve,
                duration: state.widget.transition,
                margin: EdgeInsets.only(bottom: bottom / ratio),
                height: changes.abs() / ratio,
                color: color,
              ),
            ]);
          }),
        ),
        SizedBox(
          height: state.widget.volumeHeight,
          child: ItemBuilder(index, (height) {
            final ratio = state.maxVolume.value / height;
            return Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AnimatedContainer(
                  curve: state.widget.curve,
                  duration: state.widget.transition,
                  color: color,
                  height: item.volume / ratio,
                ),
              ),
            );
          }),
        ),
      ]),
    );
  }
}

class ItemBuilder extends StatelessWidget {
  final int index;
  final Widget Function(double height) builder;
  ItemBuilder(this.index, this.builder, {Key? key}) : super(key: key);

  final state = Get.find<ChartState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Obx(() {
          if (index < state.start.value || index >= state.end.value) {
            return const SizedBox();
          }

          return builder(constraints.maxHeight);
        });
      },
    );
  }
}

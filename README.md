# simple_candlestick_chart [![pub package](https://img.shields.io/pub/v/simple_candlestick_chart.svg)](https://pub.dartlang.org/packages/simple_candlestick_chart)

A simple candlestick chart for flutter. Supports smooth scroll and zoom.

https://user-images.githubusercontent.com/1709072/146329928-de47e1b1-71eb-42b1-85c5-a63a22c8a98d.mp4

## Usage

```dart
import 'package:simple_candlestick_chart/simple_candlestick_chart.dart';

final data = [
  CandlestickData(DateTime.parse('2020-01-01 09:15'), 3990.99, 3991.17, 3990.78, 3993.55, 12869.11),
  CandlestickData(DateTime.parse('2020-01-01 09:00'), 3991.17, 3989.5, 3985.87, 3993.37, 13191.45),
  ...
];

SimpleCandlestickChart(
  data: data,
  increaseColor: Colors.teal,
  decreaseColor: Colors.redAccent,
);
```

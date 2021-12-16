import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_candlestick_chart/simple_candlestick_chart.dart';

void main() {
  runApp(const App());
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  const CustomScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  var data = <CandlestickData>[];

  @override
  void initState() {
    super.initState();
    DateTime.parse('2020-01-01');
    rootBundle.loadString('asset/data.json').then((json) {
      CandlestickData map(item) => CandlestickData(
            DateTime.fromMillisecondsSinceEpoch(item['time'] * 1000),
            item['open'].toDouble(),
            item['high'].toDouble(),
            item['low'].toDouble(),
            item['close'].toDouble(),
            item['vol'].toDouble(),
          );
      final items = jsonDecode(json) as List<dynamic>;
      setState(() {
        data = items.map<CandlestickData>(map).toList().reversed.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const CustomScrollBehavior(),
      home: Scaffold(
        body: SafeArea(
          child: Column(children: [
            SizedBox(
              height: 300,
              child: SimpleCandlestickChart(
                data: data,
                increaseColor: Colors.teal,
                decreaseColor: Colors.pinkAccent,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

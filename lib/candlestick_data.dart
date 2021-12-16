class CandlestickData {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  const CandlestickData(
    this.time,
    this.open,
    this.high,
    this.low,
    this.close,
    this.volume,
  );

  @override
  String toString() => '($time, $open, $high, $low, $close, $volume)';
}

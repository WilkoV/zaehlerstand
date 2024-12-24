class MeasureDuration {
  static int measureDuration(Function function) {
    final stopwatch = Stopwatch()..start();
    function();
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  static int calculateDuration(DateTime start, DateTime end) {
    return end.difference(start).inMilliseconds;
  }
}
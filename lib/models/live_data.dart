import 'dart:math';

class LiveData {
  final int time;
  final int value;
  LiveData({required this.time, required this.value});

  static List<LiveData> getChartData() {
    List<LiveData> data = [];
    int value = 93;
    for (int i = 0; i < 60; i++) {
      value = value + 6;
      data.add(LiveData(time: 30 * i, value: Random().nextInt(499)));
    }
    return data;
  }
}

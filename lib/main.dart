import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tata_steel_smart_shift/models/staff_api_model.dart';
import 'package:tata_steel_smart_shift/utils/helper.dart';
import 'package:tata_steel_smart_shift/widgets/appbar_title.dart';

import 'models/live_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tata Steel Smart Shift',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Smart Shift Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = true;
  double h = 150;
  StaffApiModel? apiData;
  ValueNotifier<String> selectedPlantName = ValueNotifier('');

  late List<LiveData> chartData;

  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    chartData = LiveData.getChartData();
    // Timer.periodic(const Duration(seconds: 1), (timer) => updateDataSource);
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      h = MediaQuery.of(context).size.height;

      apiData = Helper().decodeApiData();
      setState(() {
        isLoading = false;
      });
    });
  }

  int time = 0;
  void updateDataSource(Timer timer) {
    chartData.add(LiveData(time: 30 * time++, value: Random().nextInt(499)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
      addedDataIndex: chartData.length - 1,
      removedDataIndex: 0,
    );
  }

  void updatePlantName(String x) {
    print('i ran');
    selectedPlantName.value = x;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              ConstrainedBox(
                constraints: const BoxConstraints.tightFor(height: 100),
                child: const Row(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Expanded(flex: 6, child: AppbarTitle()),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    DataTileWithDropdown(
                      title: 'Plant',
                      initialData: apiData!,
                      update: updatePlantName,
                    ),
                    DataTile(
                      title: 'Date',
                      data: apiData!.date,
                    ),
                    DataTile(
                      title: 'Shift',
                      data: apiData!.deptName,
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        constraints: const BoxConstraints.expand(),
                        child: selectedPlantName.value.isEmpty
                            ? const Center(
                                child: Text(
                                    'Please select the plant name to view the graph.'),
                              )
                            : SfCartesianChart(
                                series: <LineSeries<LiveData, int>>[
                                  LineSeries<LiveData, int>(
                                    onRendererCreated:
                                        (ChartSeriesController controller) {
                                      _chartSeriesController = controller;
                                    },
                                    dataSource: chartData,
                                    color: Colors.black,
                                    yValueMapper: (LiveData shift, _) =>
                                        shift.value,
                                    xValueMapper: (LiveData shift, _) =>
                                        shift.time,
                                  ),
                                ],
                                primaryXAxis: NumericAxis(
                                  majorGridLines:
                                      const MajorGridLines(width: 0.7),
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  interval: 30,
                                  title: AxisTitle(text: 'Time(seconds)'),
                                  visibleMaximum: 900,
                                  autoScrollingMode: AutoScrollingMode.end,
                                ),
                                primaryYAxis: NumericAxis(
                                    axisLine: const AxisLine(width: 0),
                                    majorTickLines:
                                        const MajorTickLines(size: 0),
                                    title: AxisTitle(text: 'People Present'),
                                    visibleMinimum: 0,
                                    visibleMaximum: 600,
                                    plotBands: [
                                      PlotBand(
                                        borderColor: Colors.black,
                                        borderWidth: 1,
                                        color: Colors.green[100]!,
                                        start: 103,
                                        end: 500,
                                      ),
                                      PlotBand(
                                        borderColor: Colors.black,
                                        borderWidth: 1,
                                        color: Colors.yellow[100]!,
                                        start: 102,
                                        end: 0,
                                      ),
                                      PlotBand(
                                          borderColor: Colors.black,
                                          borderWidth: 1,
                                          start: 501,
                                          color: Colors.red[100]!),
                                    ]),
                              ),
                      ),
                    ),
                    const DataTile(
                      title: 'Remark',
                      data: 'Some remark',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ]),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // )
    );
  }
}

class DataTile extends StatelessWidget {
  final String title;
  final String data;
  const DataTile({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: TextField(
                readOnly: true,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                controller: TextEditingController(text: data)),
          )
        ],
      ),
    );
  }
}

class DataTileWithDropdown extends StatelessWidget {
  final String title;
  final StaffApiModel initialData;
  final void Function(String) update;

  DataTileWithDropdown({
    super.key,
    this.title = 'Plant Name',
    required this.initialData,
    required this.update,
  });

  ValueNotifier<List<DropdownMenuItem<String>>> data = ValueNotifier([]);

  DropdownMenuItem<String> buildItem(StaffApiModel m) {
    return DropdownMenuItem(
      value: m.plantName,
      child: Text(m.plantName),
    );
  }

  List<DropdownMenuItem<String>> updateList(
      List<DropdownMenuItem<String>> oldData, StaffApiModel dataToAdd) {
    String value = dataToAdd.plantName;
    List<DropdownMenuItem<String>> newList = [];
    if (oldData.isNotEmpty) {
      oldData.forEach((element) {
        String storedVal = element.value!;
        if (storedVal == value) {
          //already there
        } else {
          newList.add(buildItem(dataToAdd));
        }
      });
      return newList;
    } else {
      newList.add(buildItem(dataToAdd));
      return newList;
    }
  }

  @override
  Widget build(BuildContext context) {
    data.value = [buildItem(initialData)];
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
              child: Text(
            title,
            style: const TextStyle(fontSize: 18),
          )),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: DropdownButtonFormField(
              items: data.value,
              onChanged: (x) {
                print('changed to $x');
                update(x ?? '');
              },
              onTap: () {
                print('tapped');
                StaffApiModel m = Helper().decodeApiData();
                List<DropdownMenuItem<String>> updList =
                    updateList(data.value, m);
                data.value = updList;
              },
              decoration: InputDecoration(border: OutlineInputBorder()),
            ),

            // TextField(
            //     readOnly: true,
            //     decoration: const InputDecoration(border: OutlineInputBorder()),
            //     controller: TextEditingController(text: data)),
          )
        ],
      ),
    );
  }
}

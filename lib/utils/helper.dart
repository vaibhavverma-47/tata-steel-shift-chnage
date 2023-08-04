import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:tata_steel_smart_shift/models/staff_api_model.dart';
import 'package:tata_steel_smart_shift/utils/constants.dart';

class Helper {
  String getFormattedCurrentDate() {
    return DateFormat.yMd().format(DateTime.now()).toString();
  }

  String getFormattedCurrentTime() {
    return DateFormat.Hms().format(
      DateTime.now(),
    );
  }

  String getFormattedDate() {
    DateTime t = DateTime.now();
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Jun',
      'Jul',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${t.day}-${months[t.month]}-${t.year}';
  }

  String genApiData() {
    return '{"$dateNameApiKey": "${getFormattedDate()}" ,  "$plantNameApiKey": "BlastFurnace",  "$deptNameApiKey": "HBF"}';
  }

  StaffApiModel decodeApiData() {
    Map<String, dynamic> data = jsonDecode(genApiData());
    return StaffApiModel(
        plantName: data[plantNameApiKey] ?? '',
        deptName: data[deptNameApiKey] ?? '',
        date: data[dateNameApiKey] ?? '');
  }
}

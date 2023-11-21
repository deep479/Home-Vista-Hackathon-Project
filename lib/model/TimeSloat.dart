// ignore_for_file: unnecessary_new, file_names

class TimeSloat {
  List<TimeslotData>? timeslotData;
  String? responseCode;
  String? result;
  String? responseMsg;

  TimeSloat(
      {this.timeslotData, this.responseCode, this.result, this.responseMsg});

  TimeSloat.fromJson(Map<String, dynamic> json) {
    if (json['TimeslotData'] != null) {
      timeslotData = <TimeslotData>[];
      json['TimeslotData'].forEach((v) {
        timeslotData!.add(new TimeslotData.fromJson(v));
      });
    }
    responseCode = json['ResponseCode'];
    result = json['Result'];
    responseMsg = json['ResponseMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (timeslotData != null) {
      data['TimeslotData'] = timeslotData!.map((v) => v.toJson()).toList();
    }
    data['ResponseCode'] = responseCode;
    data['Result'] = result;
    data['ResponseMsg'] = responseMsg;
    return data;
  }
}

class TimeslotData {
  String? status;
  List<String>? days;
  List<String>? timeslot;

  TimeslotData({this.status, this.days, this.timeslot});

  TimeslotData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    days = json['days'].cast<String>();
    timeslot = json['timeslot'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['days'] = days;
    data['timeslot'] = timeslot;
    return data;
  }
}

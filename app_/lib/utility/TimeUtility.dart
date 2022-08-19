import 'package:intl/intl.dart';

class TimeUtility{
  DateTime? _dateTime;
  TimeUtility({DateTime? dateTime}){
    dateTime??= DateTime.now();
    this._dateTime = dateTime;
  }

  void updateTime(){
    this._dateTime = DateTime.now();
  }

  List<int> _getDifferent(DateTime target, {DateTime? target2}){
    //0:00:05.002177
    target2 ??= DateTime.now();
    Duration diff = target2.difference(target);
    List<int> _diffResult = <int>[
      diff.inDays,
      diff.inHours,
      diff.inMinutes,
      diff.inSeconds,
    ];

    return _diffResult;
  }

  String getBeforeString(DateTime target, {DateTime? target2}){
    //day, hours, min, sec
    List<String> stringUnit = [
      '일 전',
      '시간 전',
      '분 전',
      '초 전',
      '방금'
    ];

    List<int> diffResult = this._getDifferent(target, target2: target2);
    int targetIndex = -1;
    for (int i = 0 ; i < diffResult.length ; i++){
      if (diffResult[i] != 0){ targetIndex = i; break; }
    }

    if (targetIndex == -1){ return stringUnit[stringUnit.length -1]; }
    return "${diffResult[targetIndex]} ${stringUnit[targetIndex]}";
  }

  String _getWeekString(){
    //혹시 모르니 0과 7을 일요일로 설정
    List<String> week = ['일', '월', '화', '수', '목', '금' ,'토' ,'일'];

    return week[this._dateTime!.weekday];
  }

  String getSummeryString(){
    // 10:33 월
    return '${DateFormat("HH:mm").format(this._dateTime!)} {this._getWeekString()}';
  }

  String getDateString({String? joinString}){
    joinString??= '-';
    String resultDate = "${DateFormat("yyyy-MM-dd").format(this._dateTime!)}".split('-').join(joinString);
    //2021-03-21
    return resultDate;  
  }

  String getTimeStirng(String? joinString){
    // 10:00:24
    joinString ??= '-';
    String resultTime = "${DateFormat("HH-mm-ss").format(this._dateTime!)}".split('-').join(joinString);
    return resultTime;
  }
}
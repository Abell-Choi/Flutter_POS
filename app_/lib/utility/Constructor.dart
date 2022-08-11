import 'package:intl/intl.dart'; 
class OptionData{
}

class LogPreset{
  DateTime _dateTime;
  List<goodsPreset> _sellList ;
  LogPreset(DateTime this._dateTime, List<goodsPreset> this._sellList);
}

class goodsPreset{
  DateTime _updateTime;
  int _code;
  String _name;
  int? count;

  goodsPreset(this._updateTime, this._code, this._name, {this.count});
}
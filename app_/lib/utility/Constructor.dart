import 'dart:ffi';

import 'package:intl/intl.dart'; 
class OptionData{
}

class LogPreset{
  DateTime _dateTime;
  List<GoodsPreset> _sellList ;
  LogPreset(DateTime this._dateTime, List<GoodsPreset> this._sellList);
}

class GoodsPreset{
  DateTime? updateTime;
  int code;
  String img;
  String name;
  int count;
  int price;

  GoodsPreset({
    this.updateTime = null,
    this.code = -1,
    this.img = 'http://cdn.gameple.co.kr/news/photo/202111/200377_200534_83.gif',
    this.name = 'test',
    this.count = 1,
    this.price = 1000
  }){
    this.updateTime ??= DateTime.now();
  }

  Map<String, dynamic> getMapData(){
    return {
      this.code.toString():{
        'updateTime' : this.updateTime.toString(),
        'code' : this.code,
        'img' : this.img,
        'name' : this.name,
        'count' : this.count,
        'price' : this.price
      }
    };
  }

  void convertMapToClass(Map<String, dynamic> data){
    this.updateTime = DateTime.tryParse(data['updateTime']);
    this.code = data['code'];
    this.img = data['img'];
    this.name = data['name'];
    this.count = data['count'];
    this.price = data['price'];
  }
}
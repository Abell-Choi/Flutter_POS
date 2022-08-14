import 'dart:convert';

import 'package:intl/intl.dart'; 
class OptionData{
}

class LogPreset{
  DateTime? updateTime;
  String? uuid;
  List<GoodsPreset>? goodsPresets;
  List<String> _defaultKeyList = ['updateTime', 'uuid', 'goodsPresets'];

  LogPreset(String this.uuid, List<GoodsPreset> this.goodsPresets){
    this.updateTime = DateTime.now();
  }

  //MapData로 반환 (Stringify 화)
  Map<String, dynamic> getMapData(){  
    Map<String ,dynamic> _data = {
      'updateTime' : this.updateTime.toString(),
      'uuid' : this.uuid
    };

    List<String> goodsLists = [];
    if (goodsPresets == null) { 
      _data['goodsPresets']=[];
      Map<String, dynamic> _resultData = {
        this.uuid! : Map.from(_data)
      };
      return _resultData;
    }
    else{
      for (var i in this.goodsPresets!){
        goodsLists.add(jsonEncode(i!.getMapData()));
      }
    }

    _data['goodsPresets'] = goodsLists;
    return {this.uuid! : Map.from(_data)};
  }

  //MapData -> Class 변환
  bool convertMapToClass(Map<String ,dynamic> data){
    //uuid:{updatetime, uuid, goodsPresets}
    for (String i in this._defaultKeyList){
      if (data.keys.toList().indexOf(i) == -1){
        return false;
      }
    }

    if (DateTime.tryParse(data['updateTime']) == null){
      return false;
    } this.updateTime = DateTime.tryParse(data['updateTime'])!; 

    this.uuid = data['uuid'];
    this.goodsPresets = <GoodsPreset>[];
    for (var i in data['goodsPresets']){
      if (i == null) { this.goodsPresets = null; return true; }
      GoodsPreset _convertData = GoodsPreset();
      _convertData.convertMapToClass(i);
      this.goodsPresets!.add(_convertData);
    }
    return true;
  }
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
import 'package:app_/utility/DBManager.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class OptionData {
  DateTime? updateTime;
  bool isLogDBMode = false;
  bool isGoodsDBMode = false;
  String _dbUri = 'http://127.0.0.1';
  String _dbID = 'root';
  String _dbPW = 'root1234';
  DBManager? _db;
}

class LogPreset {
  DateTime? updateTime;
  String? uuid;
  List<GoodsPreset>? goodsLists;
  bool? isKakaoPay;

  LogPreset({this.updateTime, this.uuid, this.goodsLists, this.isKakaoPay}) {
    this.updateTime ??= DateTime.now();
    this.uuid ??= Uuid().v4();
    this.goodsLists ??= <GoodsPreset>[];
    this.isKakaoPay ??= false;
  }

  int getAllItemCount() {
    if (this.goodsLists!.length == 0) {
      return 0;
    }
    int stack = 0;
    for (var i in this.goodsLists!) {
      stack = stack + i.count;
    }

    return stack;
  }

  int getItemTypeCount() {
    return this.goodsLists!.length;
  }

  int getAllPrice() {
    int stack = 0;
    if (this.goodsLists!.length == 0) {
      return 0;
    }
    for (var i in this.goodsLists!) {
      stack += i.getAllPrice();
    }
    return stack;
  }

  Map<String, dynamic> getMapData() {
    List<Map<String, dynamic>> _listTemp = [];
    for (var i in this.goodsLists!) {
      _listTemp.add(i.getSimpleMapData());
    }
    Map<String, dynamic> _temp = {
      this.uuid!: {
        'uuid': this.uuid!,
        'updateTime': this.updateTime!.toString(),
        'goodsLists': _listTemp,
        'isKakaoPay': this.isKakaoPay,
      }
    };
    print(_temp);
    return _temp;
  }

  Map<String, dynamic> getSimpleMapData() {
    Map<String, dynamic> _temp = {
      'uuid': this.uuid!,
      'updateTime': this.updateTime!.toString(),
      'goodsLists': [],
      'isKakaoPay': this.isKakaoPay
    };

    for (var i in this.goodsLists!) {
      _temp['goodsLists'].add(i.getSimpleMapData());
    }

    print(_temp);

    return _temp;
  }

  void convertMapToClass(Map<String, dynamic> logMap) {
    Map<String, dynamic> _copy;
    if (logMap.keys.toList().length == 1) {
      _copy = Map.from(logMap);
      logMap = Map.from(_copy[_copy.keys.toList()[0]]);
    }

    this.updateTime = DateTime.tryParse(logMap['updateTime']);
    this.uuid = logMap['uuid'];
    this.goodsLists = <GoodsPreset>[];
    this.isKakaoPay = logMap['isKakaoPay'];
    for (var i in logMap['goodsLists']) {
      GoodsPreset _gd = GoodsPreset();
      _gd.convertMapToClass(i);
      this.goodsLists!.add(_gd);
    }
  }
}

class GoodsPreset {
  DateTime? updateTime;
  int code;
  String img;
  String name;
  int count;
  int price;
  bool isValid;

  GoodsPreset(
      {updateTime = null,
      this.code = -1,
      this.img =
          'http://cdn.gameple.co.kr/news/photo/202111/200377_200534_83.gif',
      this.name = 'test',
      this.count = 1,
      this.price = 1000,
      this.isValid=true}) {
    if (updateTime == null) {
      this.updateTime = DateTime.now();
    } else {
      this.updateTime = updateTime;
    }
  }

  int getAllPrice() {
    return this.count * this.price;
  }

  Map<String, dynamic> getMapData() {
    return {
      this.code.toString(): {
        'updateTime': this.updateTime.toString(),
        'code': this.code,
        'img': this.img,
        'name': this.name,
        'count': this.count,
        'price': this.price,
        'isValid' : this.isValid
      }
    };
  }

  Map<String, dynamic> getSimpleMapData() {
    return {
      'updateTime': this.updateTime.toString(),
      'code': this.code,
      'img': this.img,
      'name': this.name,
      'count': this.count,
      'price': this.price,
      'isValid' : this.isValid
    };
  }

  void convertMapToClass(Map<String, dynamic> data) {
    if (data.keys.toList().length == 1) {
      Map<String, dynamic> _copy = Map.from(data);
      data = Map.from(_copy[_copy.keys.toList()[0]]);
    }

    this.updateTime = DateTime.tryParse(data['updateTime']);
    this.code = data['code'];
    this.img = data['img'];
    this.name = data['name'];
    this.count = data['count'];
    this.price = data['price'];
    this.isValid = data['isValid'];
  }
}
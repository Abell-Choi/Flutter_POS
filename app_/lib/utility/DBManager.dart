import 'package:app_/utility/Constructor.dart';

class DBManager{
  String url;
  String id;
  String passwd;
  dynamic _dioSession;  // diosession으로 통신할 에정

  DBManager(String this.url, String this.id, String this.passwd);


  Future<Map<String, dynamic>> connect() async {
    return {};
  }

  // requesting for Logs //

  Future<Map<String ,dynamic>> getAllLogData() async {
    return {};
  }

  Future<Map<String, dynamic>> getLogData(String uuid) async{
    return {};
  }

  Future<Map<String, dynamic>> getLogLists() async {
    return {};
  }


  // requesting for Goods //

  Future<Map<String, dynamic>> getAllGoodsData() async {
    return {};
  }

  Future<Map<String, dynamic>> getGoodsData(String code) async{
    return {};
  }

  Future<Map<String, dynamic>> getGoodsLists() async{
    return {};
  }

  // update goods Data
  Future <Map<String, dynamic>> addGoodsData(GoodsPreset goodsPreset) async {
    return {};
  }

  Future <Map<String, dynamic>> overwrittingGoodsData(List<GoodsPreset> goodsPresets) async{
    return {};
  }

  Future <Map<String, dynamic>> delGoodsData(int goodsCode) async {
    return {};
  }

}
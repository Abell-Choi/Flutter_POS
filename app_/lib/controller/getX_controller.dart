import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

// custom calsses
import '../utility/Constructor.dart';
import '../utility/FileManager.dart';

class GetController extends GetxService {
  static GetController get to => Get.find();
  final isInitialized = false.obs;
  Map<String, dynamic>? _optionData;
  List<GoodsPreset> _goodsDB = [];
  List<LogPreset> _selLogDB = [];

  // -------- PERMISSIONS -------- //
  // 권한 확인

  // -------- LOG WORKING -------- //

  Future<Map<String, dynamic>> addSelLogData(List<GoodsPreset> selGoods, {bool? isKakaoPay}) async{
    isKakaoPay??=false;
    LogPreset _log = LogPreset(goodsLists: selGoods, isKakaoPay: isKakaoPay);
    this._selLogDB.add(_log);
    return this.saveSelLogData();
  }

  List<LogPreset> getSelLogData(){
    List<LogPreset> _log = List.from(this._selLogDB);
    return _log;
  }

  Future<Map<String, dynamic>> loadSelLogData() async {
    Map<String ,dynamic> _res = await FileManager().getSelLogFile();
    if (_res['res'] == 'err') {
      return _res;
    }

    if (_res['res'] == 'no'){
      await this.saveSelLogData();
      return _res;
    }

    this._selLogDB = List.from(_res['value']);
    return {'res' : 'ok', 'value' : 'data synced -> count -> ${this._selLogDB.length}'};
  }

  Future<Map<String, dynamic>> saveSelLogData() async {
    if (this._selLogDB.length == 0) {this._selLogDB.add(LogPreset());}
    return FileManager().overwrittingSelLogData(this._selLogDB);
  }

  // -------- GOODS WORKING -------- //

  // goods 디비 업데이트
  Future<Map<String, dynamic>> loadGoodsDB() async {
    List<GoodsPreset> db = await FileManager().getGoodsDB();
    _goodsDB = db;
    return {'res' : 'ok', 'value' : 'update db\ndb Count -> ${this._goodsDB.length}'};
  }

  Future<Map<String, dynamic>> _saveGoodsDB() async {
    if (this._goodsDB.length == 0) { this._goodsDB.add(GoodsPreset()); }
    return FileManager().overwrittingGoodsData(this._goodsDB);
  }

  // goods 존재 확인
  Map<String, dynamic> existGoodsData(int code){
    for (var i in _goodsDB){
      if (i.code == code){
        return {'res' : 'ok', 'value' : true};
      }
    }

    return {'res' : 'ok', 'value' : 'false'};
  }

  GoodsPreset? getGoodsData(int code){
    for (var i in this._goodsDB){
      if (i.code == code){ return i; }
    }
    return null;
  }




  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  Future<void> initialize() async {
    //임의의 초기화 루틴들 (await 걸어줘야함)
    await loadGoodsDB();
    await loadSelLogData();

    isInitialized.value = true;
    return;
  }
}
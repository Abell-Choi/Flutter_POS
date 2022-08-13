import 'package:get/get.dart';
import 'package:flutter/material.dart';

// custom calsses
import '../utility/Constructor.dart';

class GetController extends GetxService {
  static GetController get to => Get.find();
  final isInitialized = false.obs;
  Map<String, dynamic>? _optionData;
  Map<String, dynamic>? _goodsData;

  // -------- OPTIONS -------- //
  // 메모리 옵션 확인
  Map<String, dynamic> getOption(){
    if (_optionData == null) return {'res' : 'err' , 'value' : 'null data'};
    return {'res' : 'ok', 'value' : this._optionData!};
  }

  // 변경된 옵션 저장
  Map<String, dynamic> setOption( Map<String, dynamic> optionData ){

    return {};
  }

  // 옵션 확인
  Future<Map<String, dynamic>> _getOptionFile() async {

    return {};
  }

  // 옵션 저장
  Future<Map<String, dynamic>> setOptionFile(Map<String, dynamic> optionData) async{
    this._optionData = optionData;
    return {};
  }

  // -------- PERMISSIONS -------- //
  // 권한 확인
  Future<Map<String, dynamic>> _getPermission() async {

    return {};
  }

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  Future<void> initialize() async {
    //임의의 초기화 루틴들 (await 걸어줘야함)

    isInitialized.value = true;
    return;
  }
}
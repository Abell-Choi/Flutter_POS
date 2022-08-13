import 'package:get/get.dart';
import 'package:flutter/material.dart';

// custom calsses
import '../utility/Constructor.dart';

class GetController extends GetxService {
  static GetController get to => Get.find();
  final isInitialized = false.obs;
  Map<String, dynamic>? _optionData;
  List<GoodsPreset> _goodsDB = [];

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
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class GetController extends GetxController {
  final isInitialized = false.obs;
  Map<String, dynamic>? _optionData;

  // -------- OPTIONS -------- //
  // 옵션 확인
  Future<Map<String, dynamic>> _getOption() async {

    return {};
  }

  // 옵션 저장
  Future<Map<String, dynamic>> setOptions(Map<String, dynamic> optionData) async{
    this._optionData = optionData;
    return {};
  }

  // -------- PERMISSIONS -------- //
  // 권한 확인
  Future<Map<String, dynamic>> _getPermission() async {

    return {};
  }

  void increment() async{
    
  }
}
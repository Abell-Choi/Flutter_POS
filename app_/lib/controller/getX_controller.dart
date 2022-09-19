import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

// custom calsses

class GetController extends GetxService {
  static GetController get to => Get.find();
  final isInitialized = false.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  @override
  Future<void> initialize() async {

    await Future.delayed(Duration(seconds: 10));
    isInitialized.value = true;
    return;
  }
}
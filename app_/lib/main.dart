import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 

// Controller
import './controller/getX_controller.dart';

void main() {
  runApp(GetMaterialApp(home: MyApp(),));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MainPage();
}

class _MainPage extends State<MyApp> {
  final _getController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    //Future Builder든 뭐든 사용해야함
    return Obx(() { 
          if (_getController.isInitialized.value) {
            return Center(child: Text('Initialization Success.'));
          } else {
            return _Initializing();
          }
        }
    );  }
}

class _Initializing extends StatelessWidget {
  const _Initializing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text('Initializing...')
          ],
        ),
      ),
    );
  }
}
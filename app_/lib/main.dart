import 'package:app_/pages/root_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controller
import './controller/getX_controller.dart';

// root page
import './pages/root_page.dart' as rootPage;

void main() {
  runApp(GetMaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MainPage();
}

class _MainPage extends State<MyApp> {
  final AppController = Get.put(GetController());

  @override
  Widget build(BuildContext context) {
    //Future Builder든 뭐든 사용해야함
    return Obx(() {
      print(AppController.isInitialized.value);
      if (AppController.isInitialized.value) {
        return rootPage.Root_Page();
      } else {
        print('running');
        return _Initializing();
      }
    });
  }
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
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                "Initializing...",
                style: TextStyle(
                  fontSize: 24
                ),  
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
import '../../controller/getX_controller.dart';
import '../../utility/WidgetUtility.dart';

class Setting_Page extends StatefulWidget {
  const Setting_Page({super.key});

  @override
  State<Setting_Page> createState() => _Setting_Page_State();
}

class _Setting_Page_State extends State<Setting_Page> {
  final AppController = Get.put(GetController());
  Size size = Size(0,0);
  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
          ]
        ),
      )
    );
  }
}
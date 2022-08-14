import 'package:app_/utility/Constructor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controller
import '../../controller/getX_controller.dart';
import '../../utility/WidgetUtility.dart';

class Calc_Root_Page extends StatefulWidget {
  const Calc_Root_Page({super.key});

  @override
  State<Calc_Root_Page> createState() => _Calc_Root_State();
}

class _Calc_Root_State extends State<Calc_Root_Page> {
  final AppController = Get.put(GetController());
  Size size = Size(0,0);
  List<LogPreset> _logs = [];

  //System Methods
  void _clearLogs(){
    this._logs.clear();
  }

  void _syncLogs() {
    List<LogPreset> log =  AppController.getSelLogData();
    log.reversed;
    this._logs = List.from(log.reversed);
  }

  @override
  void initState() {
    super.initState();
    this._clearLogs();
    this._syncLogs();
    print(this._logs[this._logs.length-1].getSimpleMapData());
  }
  //Design Methods

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height *.15,
              color: Colors.blue,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: this._logs.length,
                itemBuilder: (context, index) {
                  LogPreset target = this._logs[index];
                  String time = DateFormat("dd일 HH:mm:ss").format(target.updateTime!);
                  return ListTileWidget(size)
                          .getLogTile(
                            Icon(Icons.check_box), 
                            target.uuid!, 
                            target.getAllItemCount(), 
                            target.getItemTypeCount(), 
                            target.getAllPrice(), 
                            time, 
                            (){}, 
                            (){}
                          );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
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
  Map<String, dynamic> _totalText = {
    't1' : 'title1',
    't2' : 'title2',
    't3' : 'title3',
    'v1' : 'value1',
    'v2' : 'value2',
    'v3' : 'value3'
  };

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
            Container(
              // total priced
              height: size.height * .15,
              //color: Colors.blue,
              child: Card(
                color: Colors.white,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                                child: CustomText(this._totalText['t1'], 1)
                                    .getText()),
                            Divider(
                              thickness: 1,
                              indent: 10,
                              endIndent: 10,
                            ),
                            Flexible(
                                child: CustomText(this._totalText['v1'], 0)
                                    .getText()),
                          ],
                        ),
                      ),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: CustomText(this._totalText['t2'], 1)
                                    .getText(),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              Flexible(
                                child: CustomText(this._totalText['v2'], 0)
                                    .getText(),
                              ),
                            ],
                          )),
                      VerticalDivider(
                        width: 1,
                        thickness: 1,
                      ),
                      Flexible(
                          fit: FlexFit.loose,
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                child: CustomText(this._totalText['t3'], 1)
                                    .getText(),
                              ),
                              Divider(
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                              Flexible(
                                  child: CustomText(this._totalText['v3'], 0)
                                      .getText()),
                            ],
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ]
        ),
      )
    );
  }
}
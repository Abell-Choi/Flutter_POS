import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Controller
import '../../controller/getX_controller.dart';
import '../../utility/WidgetUtility.dart';

class Goods_Setting_Page extends StatefulWidget {
  const Goods_Setting_Page({super.key});

  @override
  State<Goods_Setting_Page> createState() => _Goods_Setting_Page_State();
}

class _Goods_Setting_Page_State extends State<Goods_Setting_Page> {
  final AppController = Get.put(GetController());
  Size size = Size(0,0);



  Map<String, dynamic> _totalText = {
    't1': '전체 상품 개수',
    't2': '활성화',
    't3': '비활성화',
    'v1': 'value1',
    'v2': 'value2',
    'v3': 'value3'
  };

  
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(0,0,0,0),
        shadowColor: Color.fromARGB(0,0,0,0),
        title: Text(
          '상품 설정',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
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
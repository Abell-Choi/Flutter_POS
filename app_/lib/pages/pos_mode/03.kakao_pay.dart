import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KakaoPay_Page extends StatelessWidget {

  NumberFormat f = NumberFormat('###,###,###,###');
  Size size = Size(0,0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 221, 88),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: size.height *.05,),
            Container(
              height: size.height *.15,
              child: Image.network(
                'https://file.mk.co.kr/meet/neds/2018/10/image_readtop_2018_613493_15384276623477538.jpg',
              ),
            ),
            Container( // KakaoPay QR-Code
              width: size.width *.9,
              height: size.width *.9,
              child: Image.network(
                'http://img.etoday.co.kr/pto_db/2017/12/20171204102107_1159758_600_800.jpg',
                fit: BoxFit.fill,  
              ),
            ),
            Container(
              height: size.height *.1,
              alignment: Alignment.center,
              child: Text(
                '결제 금액 : ${f.format(Get.arguments['calcPrice'])}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    height: size.height *.1,
                    width: size.width *.9,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.blue[300])
                      ),
                      onPressed: ()=>Get.back(result: true),
                      child: Text(
                        '결제 완료',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                        ),
                      )
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    height: size.height *.1,
                    width: size.width *.9,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red[300])
                      ),
                      onPressed: ()=> Get.back(result: false),
                      child: Text(
                        "취 소",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
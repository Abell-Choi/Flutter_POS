import 'package:flutter/material.dart';
import 'package:get/get.dart';

// pay page
import './03.kakao_pay.dart';

class PayMentPage extends StatefulWidget {
  const PayMentPage({super.key});

  @override
  State<PayMentPage> createState() => _PayMentPageState();
}

class _PayMentPageState extends State<PayMentPage> {
  Size size = Size(0,0);

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomButtons(
              btnLable: '현금',
              isKakaoPay: false,
              size: size,
              backgroundColor: Colors.green[200]!
            ).btn,
            CustomButtons(
              btnLable: '카카오페이',
              isKakaoPay: true,
              size: size,
              backgroundColor: Colors.yellow
            ).btn,
            Container(  //Move back
              width: size.width *.7,
              height: size.height *.1,
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Colors.blue[100],
                  )
                ),
                onPressed: () => Get.back(result: -1),
                child: Text(
                  '뒤로 가기',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 24
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomButtons{
  Container btn = Container();

  CustomButtons({String btnLable='test', bool? isKakaoPay, Size? size, Color backgroundColor=Colors.blue}){
    size??= Size(0,0);
    isKakaoPay ??= false;
    this.btn = Container(
      padding: EdgeInsets.all(10),
      width: size.width *.8,
      height: size.width *.8,
      child: ElevatedButton(
        child: Text(
          btnLable,
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: '맑은 고딕'
          ),
        ),
        onPressed: () async {
          int res = 0;
          if (!isKakaoPay!){ res = await Payment(isKakaoPay: false).getPayPage(); }
          else { res = await Payment(isKakaoPay: true).getPayPage(); }
          if (res == 0){ return; }
          Get.back(result: res);
        },
        style: ButtonStyle(
          backgroundColor: backgroundColor!=null?
          MaterialStatePropertyAll(backgroundColor):
          MaterialStatePropertyAll(Colors.blue[100])
        ),
      ),
    );
  }
}

class Payment{
  bool isCash = true;
  Payment({bool? isKakaoPay}){
    isKakaoPay??= false;
    this.isCash = !isKakaoPay;
    print("initStat => ${this.isCash}");
  }

  Future<int> getPayPage() async {
    if (isCash) { return 1; }
    bool? kakao_pay_result_page=  await Get.to(()=>KakaoPay_Page());
    kakao_pay_result_page??= false;
    return kakao_pay_result_page?2:0;
  }
}
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
  Size size = Size(0, 0);
  List<LogPreset> _logs = [];

  Map<String, dynamic> _totalText = {
    't1': '총 판매량',
    't2': '누적 판매금',
    't3': '고객 수',
    'v1': 'value1',
    'v2': 'value2',
    'v3': 'value3'
  };

  //System Methods
  void _clearLogs() {
    this._logs.clear();
  }

  void _syncLogs() {
    List<LogPreset> log = AppController.getSelLogData();
    log.reversed;
    this._logs = List.from(log.reversed);
    this._syncTotalTextData();
  }

  void _syncTotalTextData({bool init = false}) {
    int _totalSellCount = 0;
    int _totalPrice = 0;
    int _totalCustomerCount = 0;
    for (var i in this._logs) {
      _totalSellCount += i.getAllItemCount();
      _totalPrice += i.getAllPrice();
    }
    _totalCustomerCount = this._logs.length;

    this._totalText['v1'] = _totalSellCount.toString();
    this._totalText['v2'] = NumberFormat('###,###,###').format(_totalPrice);
    this._totalText['v3'] = _totalCustomerCount.toString();
    init ? setState(() {}) : null;
  }

  @override
  void initState() {
    super.initState();
    this._clearLogs();
    this._syncLogs();
    //print(this._logs[this._logs.length - 1].getSimpleMapData());
  }
  //Design Methods

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text(
          "결제 내역",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        shadowColor: Color.fromARGB(0, 0, 0, 0),
        backgroundColor: Colors.blue[100],
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
            Expanded(
                child: ListView.builder(
              itemCount: this._logs.length,
              itemBuilder: (context, index) {
                LogPreset target = this._logs[index];
                String time =
                    DateFormat("E HH:mm:ss").format(target.updateTime!);
                return ListTileWidget(size).getLogTile(
                    Icon(Icons.check_box),
                    target.uuid!.split('-')[0],
                    target.getAllItemCount(),
                    target.getItemTypeCount(),
                    target.getAllPrice(),
                    time, () {
                  Get.dialog(_showInformation(index));
                }, () {});
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _showInformation(int index) {
    LogPreset _target = this._logs[index];

    // var setting
    String sellingTime = DateFormat("E HH:mm:ss").format(_target.updateTime!);
    String sellingPrice =
        NumberFormat("###,###,###,###").format(_target.getAllPrice());
    String sellingAmount = _target.getAllItemCount().toString();
    return AlertDialog(
      contentPadding: EdgeInsets.all(2),
      title: Text('상세 정보'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _target.isKakaoPay!
              ? Container(
                  height: size.height * .1,
                  color: Colors.yellow,
                  child: Image.network(
                    'https://file.mk.co.kr/meet/neds/2018/10/image_readtop_2018_613493_15384276623477538.jpg',
                    fit: BoxFit.contain,
                  ),
                )
              : Container(),
          SizedBox(
            height: size.height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("결제 일시 : "), Text(sellingTime)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("결제 금액 : "), Text("$sellingPrice 원")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("수 량 : "), Text("$sellingAmount 개")],
          ),
          SizedBox(
            height: size.height * .02,
          ),
          Container(
            height: _target.isKakaoPay!?size.height * .45:size.height * .55,
            width: size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            child: ListView.builder(
              itemCount: _target.goodsLists!.length,
              itemBuilder: (context, index) {
                if (_target.goodsLists == null) { return Container(); }
                GoodsPreset _gd = _target.goodsLists![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(_gd.img),
                    title: Text(_gd.name),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("가격 : ${_gd.price}\t"),
                        Text("총액 : ${_gd.getAllPrice()}")
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("수량"),
                        Text(_gd.count.toString())
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text("확인"),
        )
      ],
    );
  }
}

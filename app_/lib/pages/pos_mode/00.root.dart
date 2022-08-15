import 'package:app_/pages/pos_mode/02.pay.dart';
import 'package:app_/utility/Constructor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

//controller or utility
import '../../controller/getX_controller.dart';
import '../../utility/WidgetUtility.dart';

// page
import '../calc_mode/00.root.dart';

class PosRoot_Page extends StatefulWidget {
  const PosRoot_Page({super.key});

  @override
  State<PosRoot_Page> createState() => _PosRootPage_State();
}

class _PosRootPage_State extends State<PosRoot_Page> {
  final AppController = Get.put(GetController());
  
  Size size = Size(0,0);
  ListTileWidget? _listTileWidget;
  TextEditingController _textEditingController = TextEditingController();
  String uuid = '';
  List<GoodsPreset> _selectedItems = [];
  Map<String, dynamic> _calcResult = {
    'title' : '전체 가격',
    'subTitleStr' : '총 수량',
    'subTitleCount' : 0,
    'barcode' : 'uid',//need fix that
    'calcPrice' : 0
  };

  int _tempAmount = 0;

  // working methods
  void _clearItems(){
    this._selectedItems.clear();
    this.uuid = Uuid().v4();
    print ('new uuid created -> ${this.uuid}');
    setState(() {});
    return;
  }

  int _getItemCodeToNum(int code){
    for (int i = 0 ; i < this._selectedItems.length ; i++){
      if (code == this._selectedItems[i].code){
        return i;
      }
    }

    return -1;
  }
  
  Future<Map<String, dynamic>> _addItem(int code) async {
    _textEditingController.clear();
    GoodsPreset? _preset = AppController.getGoodsData(code);
    if (_preset == null) {
      //no code data err
      GetSnackBar(
        title: 'Error',
        message: '해당 코드를 찾을 수 없습니다.',
        duration: Duration(seconds: 5),
      ).show();
      return {'res' : 'err', 'value' : 'no Code Data'};
    }
    // 구매 항목 추가
    for (var i in this._selectedItems){
      if (i.code == code){
        i.count ++;
        setState(() {});
        return {'res' : 'ok', 'value' : 'add count for ${code}'};
      }
    }

    this._selectedItems.add(_preset);
    setState(() {});
    return {'res' : 'ok', 'value' : 'new item added'};
  }

  Future<Map<String, dynamic>> _delItem(int itemCode) async{
    int arrayNum = this._getItemCodeToNum(itemCode);
    if (arrayNum == -1){ return {'res' : 'err', 'value' : 'some err'};}
    this._selectedItems.removeAt(arrayNum);
    setState(() { });

    return {'res' : 'ok', 'value' : 'del from $arrayNum'};
  }
  
  Future<Map<String, dynamic>> _setCountItem(int itemCode, int count) async{
    //구매 항목 갯수 수정
    return {};
  }

  // design methods
  @override
  void initState() {
    super.initState();
    _clearItems();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    int count = 0;
    int price = 0;
    for (var i in this._selectedItems){
      count = count + i.count;
      price = price + (i.count * i.price);
    }

    this._calcResult['subTitleCount'] = count;
    this._calcResult['calcPrice'] = price;
    this._calcResult['barcode'] = this.uuid.split('-')[0];
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    _listTileWidget = ListTileWidget(size);

    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(  //Drawer Menu
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: (){
                      Get.to(
                        ()=>Calc_Root_Page(),
                        arguments: ListTileWidget,
                        transition: Transition.leftToRight

                      );
                    },
                  ),
                ),
                // input controller 
                Container(
                  height: size.height *.075,
                  color: Colors.blue[100],
                  width: size.width *.7,
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _textEditingController,
                    onChanged: (value){
                      if (value.length < 6){
                        return;
                      }
                      
                      int? parse = int.tryParse(value);
                      if (parse == null) { 
                        //int error
                        return;
                      }

                      _addItem(parse);
                    },
                    keyboardType: TextInputType.number,
                    autofocus: true,
                  ),
                ),
                
                //others icons (just some... option?)
                Expanded( //Scan Mode
                  child: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.ad_units),
                  ),
                )
              ],
            ),

            // goods list view
            Expanded(
              child: ListView.builder(
                itemCount: this._selectedItems.length,
                itemBuilder: (context, index) {
                  GoodsPreset target = this._selectedItems[index];
                  return ListTileWidget(size).getItemTile(
                    Image.network(target.img),
                    target.name, 
                    target.count, 
                    target.price * target.count, 
                    target.code.toString(),
                    (){
                      Get.dialog(
                        this._AmountDialog(target.code));
                      //GetSnackBar(title: 'test',message: 'test',duration: Duration(seconds: 2),).show();
                    },
                    (){
                      Get.dialog(this._ListTileDialog(target.code));
                    }
                  );
                },
              ),
            ),
            Divider(height: 10, thickness: 2, indent: 10, endIndent: 10,),
            
            // calc result, pay
            Container(
              height: size.height *.2,
              color: Colors.red[100],
              width: size.width,
              child: Column(
                children: [
                  Container(  //Calc result
                    child: ListTileWidget(
                      size
                    ).getItemTile(
                      Icon(Icons.abc), 
                      _calcResult['title'], 
                      _calcResult['subTitleCount'], 
                      _calcResult['calcPrice'], 
                      _calcResult['barcode'],
                      (){},
                      (){}
                    ),
                  ),
                  Container(
                    width: size.width *.99,
                    height: size.height *.09,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.lightBlue[300]
                        )
                      ),

                      //결제 버튼
                      onPressed: () async {
                        if (this._selectedItems.length <= 0){
                          GetSnackBar(
                            title: '오류',
                            message: '계산할 항목이 없습니다.',
                            duration: Duration(seconds: 5),
                            snackPosition: SnackPosition.BOTTOM,
                          ).show();
                          return;
                        }
                        int? payRes = await Get.to(()=>PayMentPage(), arguments: this._calcResult);
                        payRes ??= -2;
                        if (payRes >= 1){
                          this.AppController.addSelLogData(
                            List.from(this._selectedItems),
                            uuid : uuid,
                            isKakaoPay: payRes==2?true:false,
                          );
                          this._clearItems(); 
                          return;
                        }
                      }, 
                      child: Text(
                        "결제 하기",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
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

  //Dialog
  Widget _ListTileDialog(int code){
    return AlertDialog(
      title: Text('항목 삭제'),
      content: Text("정말로 ${this.AppController.getGoodsData(code)!.name}\n항목을 삭제하시겠습니까?"),
      actions: [
        TextButton(
          child: Text('삭제'),
          onPressed: (){
            this._delItem(code);
            Get.back(result: true);
          },
        ),
        TextButton(
          child: Text('닫기'),
          onPressed: (){
            Get.back(result: false);
          },
        )
      ],
    );
  }

  // add del dialog
  Widget _AmountDialog(int code){
    TextEditingController _cont = TextEditingController();
    GoodsPreset target = this._selectedItems[_getItemCodeToNum(code)];
    _cont.text = target.count.toString();
    return AlertDialog(
      title: Text("수량 변경"),
      content: Container(
        height: size.height *.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width *.2,
              child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _cont,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    if (int.tryParse(value) == null) { 
                      print('null');
                      return; 
                    }
                    
                    setState(() {
                      target.count = int.tryParse(value)!;
                    });
                  },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: ()=>setState(() {
                    target.count++;
                    _cont.text = target.count.toString();
                  }),
                  child: Text("+"),
                ),
                TextButton(
                  onPressed: ()=>setState(() {
                    target.count--;
                    _cont.text = target.count.toString();
                  }),
                  child: Text("-"),
                )
              ],
            ),
              ElevatedButton(
                child: Text("확인"),
                onPressed: (){Get.back(result: true);},
              )
          ],
        ),
      ),
    );
  }
}




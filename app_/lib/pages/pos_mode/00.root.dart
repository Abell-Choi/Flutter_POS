import 'package:app_/pages/pos_mode/02.pay.dart';
import 'package:app_/utility/Constructor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

// Controller
import '../../controller/getX_controller.dart';
import '../../utility/FileManager.dart';

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
                    onPressed: (){},
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
                      int code = target.code;
                      print(code);
                      //GetSnackBar(title: 'test',message: 'test',duration: Duration(seconds: 2),).show();
                    },
                    (){
                      int code = target.code;
                      print('asdf');
                      Get.dialog(this._ListTileDialog(code));
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
                        if (payRes! >= 1){ this._clearItems(); return;}
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
}




// design groups
class ListTileWidget{
  Size size;
  ListTileWidget(Size this.size);
  NumberFormat f = NumberFormat('###,###,###,###');

  Widget getTest(){
    return Card(
      child: ListTile(
        onTap: (){ 
          GetSnackBar(
            title: "test list view", 
            message: 'hi',
            duration: Duration(seconds: 10), 
            snackPosition: SnackPosition.TOP,

            ).show();
          },
        leading: Icon(Icons.read_more),
        title: Text('Test ListTile Widget'),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('수량 : 100 개'),
            Text('some barcode')
          ],
        ),
        trailing: Text(
          '500 Won'
        ),
      ),
    );
  }

  Widget getCustomWidgets(
    Widget leading,
    Widget title,
    Widget subTitle,
    Widget trailing,
    Function onTap,
    Function onLongPress
  ){
    return Card(
      child: ListTile(
        leading:leading,
        title: title,
        subtitle: subTitle,
        trailing: trailing,
        onTap: () => onTap,
        onLongPress: () => onLongPress,
      ),
    );
  }

  Widget getItemTile(Widget icon, String name, int count, int allPrice, String uid, Function onTap, Function onLongPress){
    return Card(
      child: ListTile(
        onTap: ()=>onTap(),
        onLongPress: ()=> onLongPress(),
        leading: icon,
        title: Text(name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("총 수량 : ${f.format(count)}"),
            Text(uid)
          ],
        ),
        trailing: Text("${f.format(allPrice)} ₩"),
      ),
    );
  }
}
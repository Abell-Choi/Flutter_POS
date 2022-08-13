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
  Size size = Size(0,0);
  ListTileWidget? _listTileWidget;
  TextEditingController _textEditingController = TextEditingController();
  String uuid = '';
  List<Map<String, dynamic>> _selectedItems = [];

  // working methods
  void _clearItems(){
    this._selectedItems.clear();
    this.uuid = Uuid().v4();
    print ('new uuid created -> ${this.uuid}');
    return;
  }
  
  Future<Map<String, dynamic>> _addItem() async {
    // 구매 항목 추가
    return {};
  }

  Future<Map<String, dynamic>> _delItem(int itemCode) async{
    //구매 항목 제거
    return {};
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
                      if (value.length >=6 ){
                        _textEditingController.clear();
                      }
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
              child: ListView(
                children: [
                  _listTileWidget!.getTest(),
                ],
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
                      '총 수량', 
                      100, 
                      25600, 
                      'iiiiii'
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
                      onPressed: () async {
                        await FileManager()
                        ..delGoodsData(999999);
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

  Widget getDefaultListTitle(
    Widget leading,
    Widget title,
    Widget subTitle,
    Widget trailing,
    Function onTap
  ){
    return Card(
      child: ListTile(
        leading:leading,
        title: title,
        subtitle: subTitle,
        trailing: trailing,
        onTap: () => onTap,
      ),
    );
  }

  Widget getItemTile(Widget icon, String name, int count, int allPrice, String uid){
    return Card(
      child: ListTile(
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
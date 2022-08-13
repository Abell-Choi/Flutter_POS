import 'package:app_/pages/pos_mode/02.pay.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
import '../../controller/getX_controller.dart';

class PosRoot_Page extends StatefulWidget {
  const PosRoot_Page({super.key});

  @override
  State<PosRoot_Page> createState() => _PosRootPage_State();
}

class _PosRootPage_State extends State<PosRoot_Page> {
  Size size = Size(0,0);
  ListTileWidget? _listTileWidget;
  TextEditingController _textEditingController = TextEditingController();

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
                // input controller 
                Container(
                  height: size.height *.075,
                  color: Colors.blue[100],
                  width: size.width *.8,
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
                Expanded(
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
                  ElevatedButton(
                    onPressed: () => Get.to(PayMentPage()),
                    child: Text('test'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListTileWidget{
  Size size;
  ListTileWidget(Size this.size);

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
}
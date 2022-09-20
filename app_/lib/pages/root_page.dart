import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Controller
import '../controller/getX_controller.dart';

// Custom Module
import '../Utility/constructor.dart';

class Root_Page extends StatefulWidget {
  const Root_Page({super.key});

  @override
  State<Root_Page> createState() => _Root_PageState();
}

class _Root_PageState extends State<Root_Page> {
  final AppController = Get.put(GetController()); // App Controller -> with GetX
  
  // Global Var
  Size size = Size(0, 0);
  var _txtController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _txtController.clear();
  }

  @override
  Widget build(BuildContext context) {
    this.size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        shadowColor: Color.fromARGB(255, 0, 0, 255),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(1),
              children: [
                Container(
                  alignment: Alignment.center,
                  height: size.height * .2,
                  width: size.width *.5,
                  padding: EdgeInsets.all(0),
                  margin: EdgeInsets.all(0),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Container(
              // 결제 버튼
              height: size.height * .1,
              color: Colors.blue[400],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.red,
                    width: size.width * .8,
                  ),
                  Expanded(
                    child: IconButton(
                      onPressed: () {
                        print('asdf');
                      },
                      icon: Icon(Icons.abc),
                      iconSize: 50,
                    ),
                  )
                ],
              )),
          Container(
            // 아이템 코드 입력버튼
            height: size.height * .1,
            color: Colors.blue,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: size.height * .1,
                  width: size.width * .7,
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: TextField(
                    controller: this._txtController,
                    keyboardType: TextInputType.numberWithOptions(signed: true),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: "   Input Item Codes"),
                    cursorColor: Colors.black,
                    autofocus: true,
                  ),
                ),
                ElevatedButton(onPressed: () {}, child: Text('input'))
              ],
            ),
          ),
          Container(
            height: size.height * .05,
            color: Colors.blue,
          )
        ],
      ),
    );
  }
}

/**
 * 귀찮은 영수작업을 대신 처리해줄거임 ㄹㅇㅋㅋ
 */
class ReceiptContainer {
  final DateTime _createTime = new DateTime.now();
  List<ItemStack> _items = <ItemStack>[];
  DateTime _updateTime = new DateTime.now();

  /**
   * 지정된 (index) 아이템의 정보를 가져옵니다.
   */
  Map<String, dynamic>? getItemContainer(int index) {
    if (index > _items.length - 1) {
      return null;
    }
    var targetItem = _items[index];
    Map<String, dynamic> item = {
      'item_id': targetItem.item.id,
      'item_count': targetItem.value,
      'item_price': targetItem.getItemPrice(),
      'item_raw_price': targetItem.getRawPrice(),
      'item_discount_price': targetItem.getDiscountPrice(),
      'item_update_time': targetItem.update_date
    };
    return item;
  }


  /**
   * 저장된 아이템의 정보를 가져옵니다.
   */
  List<Map<String, dynamic>> getItemContainers() {
    List<Map<String, dynamic>> items = <Map<String, dynamic>>[];
    for (int i = 0; i < _items.length; i++) {
      var result = getItemContainer(i);
      if (result == null) { continue; }
      items.add(result);
    }

    return items;
  }

  int _findItem(ItemMeta item) {
    int existsLocation = -1;
    for (ItemStack i in _items) {
      existsLocation++;
      if (i.item.id == item.id) {
        break;
      }
    }
    return existsLocation;
  }

  addItem(ItemMeta item, int count) {
    int existsLocation = this._findItem(item);

    if (existsLocation != -1) {
      this._items.add(new ItemStack(item, value: count));
    } else {
      this._items[existsLocation].value =
          this._items[existsLocation].value! + count;
    }

    return;
  }

  delItem(ItemMeta item, {int count = 1}) {
    if (count < 1) {
      return;
    }
    int existsLocation = this._findItem(item);
    if (existsLocation == -1) {
      return;
    }

    _items[existsLocation].value = _items[existsLocation].value! - count;
    if (_items[existsLocation].value! < 1) {
      _items.removeAt(existsLocation);
    }
    return;
  }

  changeItem(ItemMeta item, {int count = 1}) {
    if (count < 1) {
      return;
    }
    int existsLocation = this._findItem(item);
    if (existsLocation == -1) {
      return;
    }

    this._items[existsLocation].value = count;
    return;
  }
}
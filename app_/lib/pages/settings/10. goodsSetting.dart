import 'package:app_/utility/Constructor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  Size size = Size(0, 0);

  Map<String, dynamic> _totalText = {
    't1': '전체 상품 개수',
    't2': '활성화',
    't3': '비활성화',
    'v1': 'value1',
    'v2': 'value2',
    'v3': 'value3'
  };

  List<TextEditingController> _controller = [
    TextEditingController(), //코드
    TextEditingController(), //이미지url
    TextEditingController(), //이름
    TextEditingController(), //가격
  ];

  @override
  void initState() {
    super.initState();
    refreshTextData();
  }

  @override
  void setState(VoidCallback fn) {
    refreshTextData();
    super.setState(fn);
  }

  void refreshTextData(){
    List<GoodsPreset> _list = AppController.getAllGoodsData()!;
    this._totalText['v1'] = _list.length;
    this._totalText['v2'] = AppController.getValidGoodsCount().toString();
    this._totalText['v3'] = AppController.getInvalidGoodsCount().toString();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 0, 0, 0),
          shadowColor: Color.fromARGB(0, 0, 0, 0),
          title: Text(
            '상품 설정',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await Get.dialog(_addGoodsDialog());
              },
              icon: Icon(
                Icons.add,
                color: Colors.black,
              ),
            )
          ],
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
                                    child: CustomText(
                                            this._totalText['v1'].toString(), 0)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                    child: CustomText(
                                            this._totalText['v2'].toString(), 0)
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                      child: CustomText(
                                              this._totalText['v3'].toString(),
                                              0)
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
                    itemCount: AppController.getAllGoodsData()!.length,
                    itemBuilder: (context, i) {
                      GoodsPreset _target = AppController.getAllGoodsData()![i];
                      if (_target.isValid) {
                        return ListTileWidget(size).getItemInfoTile(
                            Image.network(_target.img),
                            _target.name,
                            _target.code,
                            _target.price,
                            DateFormat("E HH:mm:ss")
                                .format(_target.updateTime!),
                            () {
                              Get.dialog(this._settingGoodsDialog(_target));
                            },
                            () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text("알 림"),
                                  content: Text("해당 항목을 비활성화 하시겠습니까?"),
                                  actions: [
                                    TextButton(
                                      onPressed: (){
                                        _target.isValid = false;
                                        setState(() { });
                                        Get.back();
                                      },
                                      child: Text("예"),
                                    ),
                                    TextButton(
                                      onPressed: (){Get.back();},
                                      child: Text("아니요"),
                                    )
                                  ],
                                )
                              );
                            });
                      }
                      return ListTileWidget(size).getItemDisableInfoTile(
                          Image.network(_target.img),
                          _target.name,
                          _target.code,
                          _target.price,
                          DateFormat("E HH:mm:ss").format(_target.updateTime!),
                          () {
                            GetSnackBar(
                              title: 'Error',
                              message: '해당 항목은 Disabled 되었습니다.',
                              duration: Duration(seconds: 5),
                              snackPosition: SnackPosition.TOP,
                            ).show();
                          },
                          () {
                            Get.dialog(AlertDialog(
                              title: Text("알림"),
                              content: Text("해당 상품을 판매가능으로 하시겠습니까?"),
                              actions: [
                                TextButton(onPressed: (){
                                  _target.isValid = true;
                                  setState(() { });
                                  Get.back();
                                }, child: Text("네")),

                                TextButton(onPressed: (){Get.back();},
                                child: Text("아니요"),)
                              ],
                            ));
                          });
                    },
                  ),
                )
              ]),
        ));
  }

  // AddGoods Dialog
  Widget _addGoodsDialog() {
    return this._defaultDialog(
      '상품 추가',
      0,
    );
  }

  Widget _settingGoodsDialog(GoodsPreset _goods) {
    return this._defaultDialog(
      '상품 수정',
      1,
      code: _goods.code.toString(),
      name: _goods.name,
      url: _goods.img,
      price: _goods.price.toString()
    );
  }

  Widget _defaultDialog(String title,
      int type,
      {String? code, String? url, String? name, String? price}) {
    if (type == 0){
      code ??= (this.AppController.getGoodsLastCode() + 1).toString();
      name ??= '';
      url ??= 'http://cdn.gameple.co.kr/news/photo/202111/200377_200534_83.gif';
      price ??= '';
    }

    for (int i = 0 ; i < _controller.length ; i++){
      this._controller[i].text = [code!, name!, url!, price!][i];
    }
    
    String errLog = '';
    return AlertDialog(
        title: Text(title),
        content: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("상품 코드"),
                  Container(
                    width: size.width*.4,
                    child: TextField(
                        controller: _controller[0],
                        keyboardType: TextInputType.number,
                    ),
                  )
                ],
              ),
              Row(  //이름
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("이름"),
                  Container(
                    width: size.width*.4,
                    child: TextField(
                        controller: _controller[1],
                        keyboardType: TextInputType.text,
                    ),
                  )
                ],
              ),
              Row(  //이미지
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("상품 사진"),
                  Container(
                    width: size.width*.4,
                    child: TextField(
                        controller: _controller[2],
                        keyboardType: TextInputType.text,
                    ),
                  )
                ],
              ),
              Row(  //가격
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("가격"),
                  Container(
                    width: size.width*.4,
                    child: TextField(
                        controller: _controller[3],
                        keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              Text("${errLog}"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              int res = type==0?createGoodsData():setGoodsData(code!);
              if (res == -1){
                //err
                GetSnackBar(
                  title: 'Error',
                  message: '항목중 빠진구간이 있습니다.',
                  duration: Duration(seconds: 5),
                ).show();
                return;
              }

              if (res == -2){
                GetSnackBar(
                  title: 'Error',
                  message: '코드는 수정할 수 없습니다!',
                  duration: Duration(seconds: 5),
                ).show();
                this._controller[0].text = code!.toString();
                return;
              }
              setState(() { });
              Get.back();
              return;

            },
            child: Text("확인")
          ),
          TextButton(
            onPressed: (){
              Get.back();
            },
            child: Text("취소"),
          )
        ],
        
      );
  }
  
  int createGoodsData(){
    //code, name, url, price
    if (
      this._controller[0].text == ''||
      this._controller[1].text == ''||
      this._controller[2].text == ''||
      this._controller[3].text == ''
    ){
      return -1;
    }

    if (AppController.existGoodsData(
      int.parse(this._controller[0].text)
    )['value'] == true){
      return -2;
    }

    AppController.addGoods(
      int.parse(this._controller[0].text), 
      this._controller[2].text, 
      this._controller[1].text, 
      int.parse(this._controller[3].text)
    );

    return 1;

  }

  int setGoodsData(String lastCode){
    if (
    this._controller[0].text == ''||
    this._controller[1].text == ''||
    this._controller[2].text == ''||
    this._controller[3].text == ''){
      return -1;
    }

    if (lastCode != this._controller[0].text){
      return -2;
    }

    this.AppController.setGoods(
      int.parse(this._controller[0].text), 
      this._controller[2].text,
      this._controller[1].text,
      int.parse(this._controller[3].text,)
    );

    return 1;
  }
}

import 'dart:convert';
import 'dart:ffi';

import 'package:app_/Utility/constructor.dart';
import 'package:intl/intl.dart'; 

/**
 * Item 구조
 * int id -> 아이디
 * String name -> 이름
 * int price -> 가격
 * String description -> 상품설명
 * String image_url -> 상품 이미지 url
 * float discount -> 할인율
 */

class ItemMeta {
  int id;
  String? name;
  int? price;
  String? description;
  String? image_url;
  double? discount;
  String? discount_reason;

  ItemMeta(this.id, {this.name, this.price, this.description, this.image_url, this.discount, this.discount_reason}){
    this.name ??= 'None';
    this.price ??= 1000;
    this.description ??= 'None';
    this.image_url ??= 'https://ac-p2.namu.la/20211108s1/d6554599261fbeb2df1fdb5d79a36984eb072812976cd5f8d3b7a4783b9607b5.png';
    this.discount = 0;
    this.discount_reason ??= 'None'; 
  }

  String toJsonString(){
    Map<String, dynamic> data = {
      "name" : this.name,
      "price" : this.price,
      "description" : this.description,
      "image_url" : this.image_url,
      "discount" : this.discount,
      "discount_reason" : this.discount_reason
    };

    return jsonEncode(data);
  }
}


/**
 * 상품 스택 구조
 ** DateTime updateDate (추가 날째),
 ** ItemMeta item 아이템 대상,
 ** Int value : 아이템 수량,
 */
class ItemStack{
  DateTime? update_date;
  ItemMeta item;
  int? value;

  ItemStack(this.item, {this.update_date, this.value}){
    this.update_date ??= DateTime.now();
    this.value ??= 1;
  }

  /**
   * 아이템의 총 가격을 알려줍니다 (할인 된 가격)
   ** @return Double
   */
  double getItemPrice(){
    //all item price 
    double price = this.item.price!.toDouble() * this.value!.toDouble();
    price = this.item.discount! == 0 ? price : price - (this.item.discount!.toDouble() * this.value!.toDouble());
    return price;
  }
  
  /**
   * discount 가 계산되지 않은 상품의 총 값을 반환합니다.
   ** @return Double
   */
  double getRawPrice(){
    return this.item.price!.toDouble() * this.value!.toDouble();
  }

  /**
   * discount 된 값만 계산해서 반환합니다.
   ** @return Double 
   */
  double getDiscountPrice(){
    return this.item.discount!.toDouble() * this.value!.toDouble();
  }

  String toJsonString(){
    Map<String, dynamic> data = {
      "update_date" : this.update_date,
      "item" : this.item.toJsonString(),
      "value" : this.value,
    };

    return jsonEncode(data);
  }
}


/**
 * 영수 처리 및 기록을 위한 함수
 **DateTime _updateDate = 작성 시간 (고정),
 **List<ItemStack> _itemStack = 판매된 아이템 종류,
 **boolean _isKakaoPay = 카카오 페이결제 여부
 */
class Receipt{
  final DateTime _updateDate = DateTime.now();
  final String _code;
  final List<ItemStack> _itemStack;
  bool _isKakaoPay;

  Receipt(this._code, this._itemStack, this._isKakaoPay){
  }


  /**
   * 해당 클래스의 총 판매액 (할인율 X)
   */
  double getAllRawPrice(){
    double priceStack = 0;
    for (ItemStack i in this._itemStack){
      priceStack += i.getRawPrice();
    }

    return priceStack;
  }

  /**
   * 해당 클래스의 총 할인액 
   */
  double getAllDiscount(){
    double discountStack = 0;
    for (ItemStack i in this._itemStack){
      discountStack += i.getDiscountPrice();
    }
    return discountStack;
  }

  /**
   * 해당 클래스의 할인율이 포함된 판매액
   */
  double getAllPrice(){
    return this.getAllRawPrice() - this.getAllDiscount();
  }

  /**
   * Json String 화
   */
  String toJsonString(){
    // itemStack List to Json
    List<String> itemStackString = [];
    for (ItemStack i in _itemStack){
      itemStackString.add(i.toJsonString());
    }
    Map<String, dynamic> data = {
      "code" : this._code,
      "_itemStack" : jsonEncode(itemStackString),
      "_isKakaoPay" : this._isKakaoPay,
      "_updateTime" : this._updateDate.toString(),
    };

    return jsonEncode(data);
  }
}
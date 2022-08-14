import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// design groups
class ListTileWidget {
  Size size;
  ListTileWidget(Size this.size);
  NumberFormat f = NumberFormat('###,###,###,###');

  Widget getTest() {
    return Card(
      child: ListTile(
        onTap: () {
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
          children: [Text('수량 : 100 개'), Text('some barcode')],
        ),
        trailing: Text('500 Won'),
      ),
    );
  }

  Widget getCustomWidgets(Widget leading, Widget title, Widget subTitle,
      Widget trailing, Function onTap, Function onLongPress) {
    return Card(
      child: ListTile(
        leading: leading,
        title: title,
        subtitle: subTitle,
        trailing: trailing,
        onTap: () => onTap,
        onLongPress: () => onLongPress,
      ),
    );
  }

  Widget getItemTile(Widget icon, String name, int count, int allPrice,
      String uid, Function onTap, Function onLongPress) {
    return Card(
      child: ListTile(
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        leading: icon,
        title: Text(name),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("총 수량 : ${f.format(count)}"), Text(uid)],
        ),
        trailing: Text("${f.format(allPrice)} ₩"),
      ),
    );
  }

  Widget getLogTile(
      Widget icon,
      String uuid,
      int allItemCount,
      int itemTypeCount,
      int allPrice,
      String datetime,
      Function onTap,
      Function onLongPress) {
    return Card(
      child: ListTile(
        onTap: () => onTap(),
        onLongPress: () => onLongPress(),
        leading: icon,
        title: Text(
          uuid,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("판매 품목수 : ${itemTypeCount}"),
                Text("총 판매수 : ${allItemCount}"),
              ],
            ),
            Text('총 가격 : ${allPrice}')
          ],
        ),
        trailing: Text(datetime),
      ),
    );
  }
}

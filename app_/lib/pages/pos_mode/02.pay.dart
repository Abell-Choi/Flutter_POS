import 'package:flutter/material.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width *.4,
              height: size.width *.4,
              child: ElevatedButton(
                onPressed: (){},
                child: Text('asdf'),
              ),
            ),
            Container()
          ],
        ),
      ),
    );
  }
}
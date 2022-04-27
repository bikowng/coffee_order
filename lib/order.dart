import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Order();

}

class _Order extends State<Order> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('주문하기'),
        ),
        body: Container(
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop('/');
              },
              child: const Text('첫번째 페이지로 이동하기'),
            ),
          ),
        )
    );
  }
}
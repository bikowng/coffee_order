import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _History();

}

class _History extends State<History> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('주문 이력'),
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
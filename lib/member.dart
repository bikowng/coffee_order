import 'package:flutter/material.dart';

class Member extends StatefulWidget {
  const Member({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Member();

}

class _Member extends State<Member> {

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
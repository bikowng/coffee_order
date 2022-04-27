import 'package:coffee_order/menuContents.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'order.dart';
import 'history.dart';
import 'menuContents.dart';
import 'member.dart';

class Home extends StatefulWidget {
  /// 전달 받은 database
  final Future<Database> db;
  Home(this.db);

  @override
  State<StatefulWidget> createState() => _Home();

}

class _Home extends State<Home> {

  // 메뉴. 초기화
  List<String> menuList = List.filled(4, '', growable: false);

  @override
  void initState() {
    super.initState();
    menuList[0] = '주문하기';
    menuList[1] = '주문 이력';
    menuList[2] = '메뉴 관리';
    menuList[3] = '멤버 관리';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: InkWell(
              child: Text(
                menuList[index],
                style: const TextStyle(fontSize: 20),
              ),
              onTap: () {
                // TODO : 나머지 페이지도 menu contents 처럼 라우터 이동으로 변경해야 함.
                switch (index) {
                  case 0:
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Order()));
                    break;
                  case 1:
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const History()));
                    break;
                  case 2:
                    Navigator.of(context).pushNamed('/menuContents');
                    break;
                  case 3:
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Member()));
                    break;
                  default:
                    // TODO : 잘못된 접근 오류 페이지로 이동
                    break;
                }
              },
            ),
          );
        },
        itemCount: menuList.length,
      )
    );
  }
}
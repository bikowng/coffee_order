/*
 * 주문하기 페이지
 * 멤버 리스트가 나오고, 멤버별 주문하기 버튼을 누르면 커피를 선택할 수 있게 한다.
 */

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'menu.dart';
import 'order.dart';

class OrderContents extends StatefulWidget {

  final Future<Database> db;
  OrderContents(this.db);

  @override
  State<StatefulWidget> createState() => _OrderContents();

}

class _OrderContents extends State<OrderContents> {

  Future<List<Order>>? orderList;

  @override
  void initState() {
    super.initState();
    orderList = _getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주문하기'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          Order order = (snapshot.data as List<Order>)[index];
                          String? buttonText = '메뉴';
                          return ListTile(
                            subtitle: Row(
                              children: <Widget>[
                                Text(order.memberName!, style: const TextStyle(fontSize: 25, color: Colors.black),),
                                Text(order.menuName!, style: const TextStyle(fontSize: 25, color: Colors.black),),
                                TextButton(onPressed:() async {
                                  final result = await Navigator.of(context).pushNamed('/orderMenu');
                                  setState(() {
                                    order.menuName = (result as Menu).title;
                                  });
                                },
                                child: const Text('선택'))
                              ],
                            ),
                          );
                        },
                      itemCount: (snapshot.data as List<Order>).length,
                    );
                  } else {
                    return const Text('No Data');
                  }
              }
              return const CircularProgressIndicator();
            },
            future: orderList,
          ),
        ),
      )
    );
  }

  Future<List<Order>> _getOrders() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('members');

    return List.generate(maps.length, (i) {
      return Order(
        memberName: maps[i]['name'].toString(),
        menuName: '',
      );
    });
  }

  Future<List<Menu>> _getMenus() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('menus');

    return List.generate(maps.length, (i) {
      int active = maps[i]['active'] == 1 ? 1 : 0;
      return Menu(
        title: maps[i]['title'].toString(),
        active: active,
        id: maps[i]['id'],
      );
    });
  }
}
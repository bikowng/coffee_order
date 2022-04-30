import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'menu.dart';

class MenuContents extends StatefulWidget {

  /// 전달 받은 database
  final Future<Database> db;
  MenuContents(this.db);

  @override
  State<StatefulWidget> createState() => _MenuContents();

}

class _MenuContents extends State<MenuContents> {

  /// 메뉴 리스트
  Future<List<Menu>>? menuList;

  @override
  void initState() {
    super.initState();
    menuList = _getMenus();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('메뉴 관리'),
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
                  if (snapshot.hasData ) {
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        Menu menu = (snapshot.data as List<Menu>)[index];

                        /// TODO : 삭제 버튼을 아이콘으로 해서 우측에 정렬할 수 있는 방법이 있을까?
                        return ListTile(
                          subtitle: Row(
                            children: <Widget>[
                              Text(menu.title!, style: const TextStyle(fontSize: 25, color: Colors.black),),
                              TextButton(
                                  onPressed: () async {
                                    Menu result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('${menu.id} : ${menu.title}'),
                                            content: const Text('Menu를 삭제하시겠습니까?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(menu);
                                                  },
                                                  child: const Text('예')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop(Menu());
                                                  },
                                                  child: const Text('아니요')),
                                            ],
                                          );
                                        });
                                    _deleteMenu(result);
                                  },
                                  child: const Text('삭제')),
                              Container(
                                height: 1,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                        );
                    },
                    itemCount: (snapshot.data as List<Menu>).length,
                    );
                  } else {
                    return const Text('No Data');
                  }
              }
              return const CircularProgressIndicator();
            },
            future: menuList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        /// 비동기 호출
        onPressed: () async {
          final menu = await Navigator.of(context).pushNamed('/menuDetail');

          if(menu != null) {
            _insertMenu(menu as Menu);
          }

        },
        child: const Icon(Icons.add),
      ),

      /// 버튼을 center 정렬할 때 사용한다. 디자인 고민 중..
      // floatingActionButtonLocation:
      //  FloatingActionButtonLocation.centerFloat,
    );
  }

  void _insertMenu(Menu menu) async {
    final Database database = await widget.db;
    /// conflict algorithm : replace = mysql upsert 개념
    /// id가 자동증가로 설정되어 있는데, 동일한 id로 insert 시 충돌이 발생함. 이때는 replace 동작.
    await database.insert('menus', menu.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    /// insert data update
    setState(() {
      menuList = _getMenus();
    });
  }

  void _deleteMenu(Menu menu) async {
    final Database database = await widget.db;
    await database.delete('menus', where: 'id=?', whereArgs: [menu.id]);
    setState(() {
      menuList = _getMenus();
    });
  }


  /// 데이터 불러오기
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
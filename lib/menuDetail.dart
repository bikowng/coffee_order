import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'menu.dart';

class MenuDetail extends StatefulWidget {
  /// 전달 받은 database
  final Future<Database> db;
  MenuDetail(this.db);

  @override
  State<StatefulWidget> createState() => _MenuDetail();

}

class _MenuDetail extends State<MenuDetail> {

  /// CONTROLLER
  /// Detail 내용을 수정하고자 하는 경우, 여기에 controller를 먼저 추가하고, body 부분에 연결한다.
  TextEditingController? titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text('메뉴 편집'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[
                // 메뉴명
                Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: '메뉴'),
                  ),
                ),
                /// 저장 버튼
                ElevatedButton(onPressed: () {
                  /// 입력한 메뉴 내용 전달
                  Menu menu = Menu(
                    title: titleController!.value.text,
                    active: 1,    // default 1 = use
                  );

                  /// 메인에 전달
                  // TODO : 여기!!!! save 할 때 메인인지 menu contents 인지 확인해야 함.
                    Navigator.of(context).pop(menu);
                }, child: const Text('저장하기'))
              ],
            ),
          ),
        )
    );
  }
}
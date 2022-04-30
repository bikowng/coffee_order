import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home.dart';
import 'memberDetail.dart';
import 'orderContents.dart';
import 'history.dart';
import 'menuContents.dart';
import 'memberContents.dart';
import 'menuDetail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = '커피 주문하기';

  @override
  Widget build(BuildContext context) {
    /// init database

    // Future<void> _database = removeDatabase();
    Future<Database> _database = initDatabase();

    return MaterialApp(
      title: _title,
      initialRoute: '/',

      // 라우터 설정
      routes: {
        '/': (context) => Home(),                             // 메인 메뉴 화면
        '/orderContents': (context) => OrderContents(_database),                         // 주문 하기
        '/orderMenu': (context) => MenuContents(_database, ''),
        '/history': (context) => const History(),                      // 주문 이력
        '/menuContents': (context) => MenuContents(_database, 'new'),  // 커피 메뉴
        '/menuDetail': (context) => MenuDetail(_database),             // 메뉴 편집
        '/memberContents': (context) => MemberContents(_database),     // 부서원 관리
        '/memberDetail': (context) => MemberDetail(_database),         // 멤버 편집
      },


    );
  }

  /// Database. 테이블이 없으면 생성한다.
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'cafe_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE menus(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, active INTEGER)",
        );
        await db.execute(
          "CREATE TABLE members(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT)",
        );
      },

        /// oncreate는 DB가 없으면 skip 함.
        /// 만약, 개발 중에 새로운 table을 추가하고자 하는 경우, skip 되어버림.
        /// onOpen에 table 생성 코드를 추가한다.
        /// 개발 완료 후에는... 삭제하는게 좋을 것 같음.
      /*
        onOpen: (db) async {
        await db.execute(
          "CREATE TABLE members(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "name TEXT)",
        );
      },

       */
      version: 1
    );
  }
}

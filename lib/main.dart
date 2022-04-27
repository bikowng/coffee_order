import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'home.dart';
import 'order.dart';
import 'history.dart';
import 'menuContents.dart';
import 'member.dart';
import 'menuDetail.dart';
import 'menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = '커피 주문하기';

  @override
  Widget build(BuildContext context) {
    /// init database
    Future<Database> database = initDatabase();

    return MaterialApp(
      title: _title,
      initialRoute: '/',
      
      // 라우터 설정
      routes: {
        '/': (context) => Home(database),                         // 메인 메뉴 화면
        '/order': (context) => const Order(),                   // 주문 하기
        '/history': (context) => const History(),               // 주문 이력
        '/menuContents': (context) => MenuContents(database),   // 커피 메뉴
        '/member': (context) => const Member(),                 // 부서원 관리
        '/menuDetail': (context) => MenuDetail(database),       // 메뉴 편집
      },
    );
  }

  /// Database. 테이블이 없으면 생성한다.
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'cafe_database.db'),
      onCreate: (db, version) {
        return db.execute(
              "CREATE TABLE menus(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, active INTEGER)",
        );
      },
      version: 1
    );
  }

}

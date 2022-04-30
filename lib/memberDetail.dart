import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'member.dart';

class MemberDetail extends StatefulWidget {
  final Future<Database> db;
  MemberDetail(this.db);

  @override
  State<StatefulWidget> createState() => _MemberDetail();
}

class _MemberDetail extends State<MemberDetail> {

  TextEditingController? nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멤버 편집'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '멤버'),
                ),
              ),
              ElevatedButton(onPressed: () {
                Member member = Member(
                  name: nameController!.value.text,
                );
                Navigator.of(context).pop(member);
              }, child: const Text('저장하기'))
            ],
          ),
        ),
      )
    );
  }
}
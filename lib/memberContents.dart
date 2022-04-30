import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'member.dart';

class MemberContents extends StatefulWidget {

  final Future<Database> db;
  MemberContents(this.db);

  @override
  State<StatefulWidget> createState() => _MemberContents();

}

class _MemberContents extends State<MemberContents> {

  Future<List<Member>>? memberList;

  @override
  void initState() {
    super.initState();
    memberList = _getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('멤버 관리'),
      ),
      body: Container(
        child: Center(
          child: FutureBuilder(
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return const CircularProgressIndicator();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          Member member = (snapshot.data as List<Member>)[index];

                          return ListTile(
                            subtitle: Row(
                              children: <Widget>[
                                Text(member.name!, style: const TextStyle(fontSize: 25, color: Colors.black),),
                                TextButton(
                                    onPressed: () async {
                                      Member result = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('${member.id} : ${member.name}'),
                                            content: const Text('멤버를 삭제하시겠습니까?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(member);
                                                },
                                                child: const Text('예')),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop(Member());
                                                },
                                                child: const Text('아니요')),
                                            ],
                                          );
                                        });
                                      _deleteMember(result);
                                    },
                                    child: const Text('삭제')),
                              ],
                            ),
                          );
                        },
                        itemCount: (snapshot.data as List<Member>).length,
                      );
                  } else {
                    return const Text('No Data');
                  }
              }
              return const CircularProgressIndicator();
            },
            future: memberList,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final member = await Navigator.of(context).pushNamed('/memberDetail');

          if(member != null) {
            _insertMember(member as Member);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  _insertMember(Member member) async {
    final Database database = await widget.db;

    await database.insert('members', member.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);

    setState(() {
      memberList = _getMembers();
    });
  }

  void _deleteMember(Member member) async {
    final Database database = await widget.db;
    await database.delete('members', where: 'id=?', whereArgs: [member.id]);

    setState(() {
      memberList = _getMembers();
    });
  }

  Future<List<Member>> _getMembers() async {
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('members');

    return List.generate(maps.length, (i) {
      return Member(
        name: maps[i]['name'].toString(),
        id: maps[i]['id'],
      );
    });
  }
}
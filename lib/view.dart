import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_app/model/person.dart';

class ViewPage extends StatefulWidget {
  final Isar isar;// Isarのインスタンスを受け取るための変数

  ViewPage({required this.isar});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<Person> persons = []; // personsはデータベースの中身を取得するための変数

  // initStateを使うと、画面が表示される前にデータベースの中身を取得できます。
  @override
  void initState() {
    super.initState();
    loadData();
  }
  // データベースの中身を取得する関数
  Future<void> loadData() async {
    final data = await widget.isar.persons.where().findAll();
    setState(() {
      persons = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('データを表示')),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return ListTile(
            title: Text(person.name ?? "値が入ってません"),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                // ここでデータベースから削除しています
                await widget.isar.writeTxn(() async {
                  await widget.isar.persons.delete(person.id);
                });
                await loadData();
              },
            )
          );
        },
      ),
    );
  }
}

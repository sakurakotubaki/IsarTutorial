import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_app/model/person.dart';
import 'package:isar_app/view.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Isarの初期化
  WidgetsFlutterBinding.ensureInitialized();
  // アプリのドキュメントディレクトリを取得
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [PersonSchema],
    directory: dir.path,
  );

  runApp(MyApp(isar: isar));
}

class MyApp extends StatelessWidget {
  final Isar isar;

  MyApp({required this.isar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddPage(isar: isar),
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.isar}) : super(key: key);

  final Isar isar;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ追加'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
            ),
            ElevatedButton(
                onPressed: () async {
                  // Personクラスのインスタンスを作成
                  final person = Person()..name = nameController.text;
                  // 入力後にテキストフィールドを空にする
                  nameController.clear();
                  // widgetとは、StatefulWidgetのこと
                  // widget.isarで、StatefulWidgetのisarを参照できる
                  await widget.isar.writeTxn(() async {
                    await widget.isar.persons.put(person);
                  });
                },
                child: const Text('追加')),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewPage(isar: widget.isar),
                ),
              );
            }, child: const Text('一覧へ'))
          ],
        ),
      ),
    );
  }
}

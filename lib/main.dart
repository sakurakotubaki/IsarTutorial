import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:isar_app/model/person.dart';
import 'package:isar_app/ui/add.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // Isarの初期化
  WidgetsFlutterBinding.ensureInitialized();
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
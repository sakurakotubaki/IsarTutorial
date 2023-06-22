import 'package:isar/isar.dart';// 1. isarパッケージをインポート
part 'person.g.dart';// ファイル名.g.dartと書く

@collection
class Person {
  Id id = Isar.autoIncrement; // id = nullでも自動インクリメントされます。

  String? name;
}
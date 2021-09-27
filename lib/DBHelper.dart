import 'package:flutter_sqflite_database/student.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DBHelper
{
  Database _database;

  openDatabse() async
  {
    if(_database==null)
    {
      var path  =  join(await getDatabasesPath(),"student.db");
      _database = await openDatabase(path,version: 1, onCreate: (Database db,int version)async{
        await db.execute("CREATE TABLE StudentList(id INTEGER PRIMARY KEY, name TEXT,div TEXT)");
      });
    }
    return _database;
  }

  Future<int> insertdata(Student student) async{
    await openDatabse();
    return await _database.insert("StudentList", student.toMap());
  }

  Future<int> deletedata(int id) async
  {
    await openDatabse();
    return await _database.delete("StudentList",where: "id = ?",whereArgs: [id]);
  }

  Future<int> updatedata(Student student) async
  {
    await openDatabse();
    return await _database.update("StudentList",student.toMap(), where: "id=${student.id}");
  }

  Future<List<Student>> readalldata() async{
    await openDatabse();
    List<Map<String,dynamic>> lststudent = await _database.query("StudentList");
    return List.generate(lststudent.length, (index){
      return Student(lststudent[index]["name"],lststudent[index]["div"],id: lststudent[index]["id"]);
    });
  }

}
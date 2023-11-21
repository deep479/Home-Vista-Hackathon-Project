// ignore_for_file: empty_catches

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:ucservice_customer/model/servicemodel.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  static String path = "userSix.db";

  static Future<Database> getDataBase() async {
    return openDatabase(
      join(await getDatabasesPath(), path),
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future _createDB(Database db, int version) async {
    const idType = " INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";

    try {
      await db.execute('''
      CREATE TABLE $tableNotes (
      ${NoteFields.id}$idType,
      ${NoteFields.serviceId} $textType,
      ${NoteFields.img} $textType,
      ${NoteFields.video} $textType,
      ${NoteFields.serviceType} $textType,
      ${NoteFields.title} $textType,
      ${NoteFields.takeTime} $textType,
      ${NoteFields.maxQuantity} $textType,
      ${NoteFields.price} $textType,
      ${NoteFields.discount} $textType,
      ${NoteFields.serviceDesc} $textType,
      ${NoteFields.status} $textType,
      ${NoteFields.isApprove} $textType
      )
      ''');
    } on DioError {}
  }

  static Future addData(Servicelist serviceList) async {
    final db = await getDataBase();
    try {
      int inserted = await db.insert(
        tableNotes,
        serviceList.toJson(),
      );
      if (kDebugMode) {
        print("inserted ::$inserted");
      }
    } catch (e) {}
  }

  static Future<int> updateUser(Servicelist serviceList) async {
    final db = await getDataBase();
    int result = await db.update(
      tableNotes,
      serviceList.toJson(),
      where: "id = ?",
      whereArgs: [serviceList.serviceId],
    );
    if (kDebugMode) {
      print("ID Result ::$result");
    }
    return result;
  }

  static Future<List<Servicelist>> getData() async {
    final Database db = await getDataBase();
    List<Map<String, Object?>> queryResult = await db.query(tableNotes);
    if (kDebugMode) {
      print("${queryResult.length}");
    }
    return List.generate(queryResult.length,
        (index) => Servicelist.fromJson(queryResult[index]));
  }
}

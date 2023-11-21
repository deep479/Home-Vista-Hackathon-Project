// ignore_for_file: file_names, avoid_print, depend_on_referenced_packages

import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

var sqfList = [];

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'sub.db'),
        onCreate: (db, version) {
      return db
          .execute('CREATE TABLE ServiceData('
              'serviceid TEXT,'
              'mtitle TEXT,'
              'quantity TEXT,'
              'img TEXT,'
              'video TEXT,'
              'servicetype TEXT,'
              'title TEXT,'
              'taketime TEXT,'
              'maxquantity TEXT,'
              'price TEXT,'
              'discount TEXT,'
              'servicedesc TEXT,'
              'status TEXT,'
              'isapprove TEXT'
              ')')
          .catchError((val) => print(val));
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(table, data);
  }

  static Future getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> deleteData(String table, String serviceid) async {
    final db = await DBHelper.database();

    db.delete(table, where: 'serviceid = ?', whereArgs: [serviceid]);
  }

  static Future<void> updateData(
      String table, String serviceid, Map<String, Object> data) async {
    final db = await DBHelper.database();

    db.update(table, data, where: 'serviceid = ?', whereArgs: [serviceid]);
  }
}

//! Model
class ServiceData {
  String? serviceid;
  String? mtitle;
  String? quantity;
  String? img;
  String? video;
  String? servicetype;
  String? title;
  String? taketime;
  String? maxquantity;
  String? price;
  String? discount;
  String? servicedesc;
  String? status;
  String? isapprove;

  ServiceData({
    this.serviceid,
    this.mtitle,
    this.quantity,
    this.img,
    this.video,
    this.servicetype,
    this.title,
    this.taketime,
    this.maxquantity,
    this.price,
    this.discount,
    this.servicedesc,
    this.status,
    this.isapprove,
  });
}

//! User Service
class UserServiceData {
  void saveServiceData({
    required String serviceid,
    required String mtitle,
    required String quantity,
    required String img,
    required String video,
    required String servicetype,
    required String title,
    required String taketime,
    required String maxquantity,
    required String price,
    required String discount,
    required String servicedesc,
    required String status,
    required String isapprove,
  }) {
    DBHelper.insert('ServiceData', {
      "serviceid": serviceid,
      "mtitle": mtitle,
      "quantity": quantity,
      "img": img,
      "video": video,
      "servicetype": servicetype,
      "title": title,
      "taketime": taketime,
      "maxquantity": maxquantity,
      "price": price,
      "discount": discount,
      "servicedesc": servicedesc,
      "status": status,
      "isapprove": isapprove,
    });
  }

  Future fetchUsers() async {
    final usersList = await DBHelper.getData('ServiceData');
    sqfList.add(usersList
        .map((item) => ServiceData(
              serviceid: item['serviceid'],
              mtitle: item["mtitle"],
              quantity: item["quantity"],
              img: item['img'],
              video: item['video'],
              servicetype: item['servicetype'],
              title: item['title'],
              taketime: item['taketime'],
              maxquantity: item['maxquantity'],
              price: item['price'],
              discount: item['discount'],
              servicedesc: item['servicedesc'],
              status: item['status'],
              isapprove: item['isapprove'],
            ))
        .toList());
    return usersList
        .map((item) => ServiceData(
              serviceid: item['serviceid'],
              mtitle: item["mtitle"],
              quantity: item["quantity"],
              img: item['img'],
              video: item['video'],
              servicetype: item['servicetype'],
              title: item['title'],
              taketime: item['taketime'],
              maxquantity: item['maxquantity'],
              price: item['price'],
              discount: item['discount'],
              servicedesc: item['servicedesc'],
              status: item['status'],
              isapprove: item['isapprove'],
            ))
        .toList();
  }

  void deleteServiceData(String serviceid) {
    DBHelper.deleteData('ServiceData', serviceid);
  }

  void updateServiceData({
    required String serviceid,
    required String quantity,
  }) {
    DBHelper.updateData('ServiceData', serviceid, {
      "serviceid": serviceid,
      "quantity": quantity,
    });
  }
}

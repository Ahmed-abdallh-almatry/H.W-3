import 'dart:async';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../const/constants.dart';

class DataUploaderController extends GetxController {
  Database? _database;
  Timer? _timer;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    _initializeDatabase();
    _startConnectivityCheck();
  }

  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'data.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE data(id INTEGER PRIMARY KEY, value TEXT)',
        );
      },
      version: 1,
    );
  }

  void _startConnectivityCheck() {
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkConnectivity();
    });
  }

  Future<void> _checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      _uploadData();
    }
  }

  Future<void> _uploadData() async {
    final List<Map<String, dynamic>> data = await _database!.query('data');
    for (var item in data) {
      try {
        final response = await _dio.post(
          apiUrl,
          data: item,
        );

        if (response.statusCode == 200) {
          await _database!.delete('data', where: 'id = ?', whereArgs: [item['id']]);
        }
      } catch (e) {
        print('Error uploading data: $e');
      }
    }
  }

  Future<void> saveData(String value) async {
    await _database!.insert(
      'data',
      {'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/database/drift_database.dart';
import 'package:fluttertest/screen/home_screen.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

const DEFAULT_COLORS = [
  // 빨강
  'EF9A9A',
  // 주황
  'FFCC80',
  // 노랑
  'FFF59D',
  // 초록
  'A5D6A7',
  // 파랑
  '90CAF9',
  // 남색
  '9FA8DA',
  // 보라
  'CE93D8',
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  final database = LocalDatabase();

  GetIt.I.registerSingleton<LocalDatabase>(database);

  final colors = await database.getCategoryColors();

  if(colors.isEmpty) {
   for(String hexCode in DEFAULT_COLORS) {
     await database.createCategoryColor(
       CategoryColorsCompanion(
         hexCode: Value(hexCode),
       ),
     );
   }
  }

  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}

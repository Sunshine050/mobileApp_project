import 'package:flutter/material.dart';
import 'package:pro_mobile/views/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Room Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // ตั้งค่าสีหลักของแอป
      ),
      home: const Homepage(), // ใช้คลาส Homepage เป็นหน้าแรก
      debugShowCheckedModeBanner: false, // ปิดแบนเนอร์โหมดตรวจสอบ
    );
  }
}

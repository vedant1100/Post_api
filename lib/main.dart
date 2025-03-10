import 'package:flutter/material.dart';
import 'package:login_register_api/uploadImage.dart';
import 'uploadText.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.grey)),
      home: const UploadText(),
    );
  }
}


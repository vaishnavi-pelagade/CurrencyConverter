import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kerela/currency_convert_screen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyConverterPage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:project_uts/screens/product_detail_screen.dart';
import 'package:project_uts/screens/products_list_screen.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //StatelessWidget  berfungsi untuk menampilkan hal-hal yang sifatnya statis (yang tidak dapat di ubah )
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UAS',// nama project
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProductListScreen(),
      routes: {
        ProductListScreen.routeName: (context) => ProductListScreen(), //untuk menghubungkan ProductListScreen
        ProductDetailScreen.routeName: (context) => ProductDetailScreen()//untuk menghubungkan ProductDetailScreen
      },
    );
  }
}

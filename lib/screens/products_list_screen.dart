import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:project_uts/models/product.dart';
import 'package:project_uts/screens/product_detail_screen.dart';



class ProductListScreen extends StatefulWidget {
  //StatefulWidget berfungsi Untuk mengubah variabel yang terdapat di dalam variabel yang telah di deklarasikan di dapat menggunakan syntax “State”.
  const ProductListScreen({ Key? key }) : super(key: key);

  static const String routeName = '/product-list';

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  Future<void> readJsonFile() async {

    final String response = await rootBundle.loadString('jsonfile/products.json');//  digunakana untuk memanggil file product.son yang ada di folder jsonfile
    final productData = await json.decode(response);
    // final berfungsi untuk nilai properti tetap dan tidak dapat di ubah
    var list = productData["items"] as List<dynamic>;

    setState(() {
      allProducts = [];
      allProducts = list.map((e) => Product.fromJson(e)).toList();
      filteredProducts = allProducts;
    });
  }

  void _runFilter(String searchKeyword) {
    List<Product> results = [];

    if(searchKeyword.isEmpty) {
      results = allProducts;
    } else {
      results = allProducts.where((element) => element.name.toLowerCase().contains(searchKeyword.toLowerCase())).toList();
    }

    // refresh the UI
    setState(() {
      filteredProducts = results;
    });

  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector( //untuk menampilkan text yang akan di panggil
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold( //Scaffold memiliki peran untuk mengatur struktur visual layout dengan mengimplementasikan material design , dimana dia juga memiliki kemampuan untuk membuat appbar
        // scanffold juga merupakan  widget utama untuk membuat sebuah halaman pada flutter
          resizeToAvoidBottomInset: true,
          appBar: AppBar(title: Text("Products List"),), // berfungsi untuk membuat text pada aplikasi dengan text product list
          body:  Column( //untuk mengatur widget agar tersusun secara vertikal (dari atas ke bawah)
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton(onPressed: readJsonFile, child: Text("Load Products")),
                ),
                  //appBar berfungsi untuk sebagai halaman utama aplikasi
                // if (allProducts.length > 0) 
          
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column( //column berfungsi untuk mengatur tampilan children secara vertikal.
                      children: [
                        SizedBox(height: 10,),
                        TextField(
                          onChanged: (value) => _runFilter(value),
                          decoration: InputDecoration(labelText: 'Search', suffixIcon: Icon(Icons.search)),
                        ),
                        SizedBox(height: 10,),
                      ],
                    ),
                  
                  ),
    
                  
                  Expanded(
                   
                      child: ListView.builder(
                        //listview berfungsi untuk membuat sebuah tampilan dengan susunan vertikal dalam bentuk daftar(List) yang bisa di scroll.
                        shrinkWrap: true,
                        itemCount: filteredProducts.length, // intemCount diguanakn untuk menentukan berapa jumlah list yang kita gunakan
                        itemBuilder: (BuildContext context, index) {
                          return Dismissible(
                            key: ValueKey(filteredProducts[index].id.toString()),
                            background: Container(
                              color: Colors.blueAccent,
                              child: Icon(Icons.delete, color: Colors.blue, size: 40),
                              padding: EdgeInsets.all(8.0),
                              margin: EdgeInsets.all(8.0),
                            ),
                            //Container fungsinya untuk membungkus widget lain sehingga dapat diberikan nilai seperti margin, padding, warna background dan title
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (direction) {
                    
                              return showDialog(
                                        context: context, 
                                        builder: (ctx) => AlertDialog(
                                          title: Text("Please Confirm"),//text digunakan untuk menampilkan string
                                          content: Text("Are you sure you want to delete?"),
                                          actions: [
                                            ElevatedButton(onPressed: (){
                                              Navigator.of(ctx).pop(false);
                                            }, child: Text("Cancel")),
                                            ElevatedButton(onPressed: (){
                                              Navigator.of(ctx).pop(true);
                                            }, child: Text("Delete")),
                                          ],
                                        ),
                                    );
                    
                    
                            },
                            onDismissed: (DismissDirection direction) {
                    
                              if(direction == DismissDirection.endToStart) {
                                filteredProducts.removeAt(index);
                              }
                    
                            },
                            child: Card(
                              margin: EdgeInsets.all(15.0),
                              color: Colors.greenAccent,
                              child: ListTile(
                                title: Padding(// padding berfungsi untuk memberikan jarak
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(filteredProducts[index].name),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(filteredProducts[index].price.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                                onTap: () { // on tap berfungsi untuk membuka text yang akan di panggil nantinya
                                  // print(jsonEncode(products[index]));
                                  Navigator.of(context).pushNamed(ProductDetailScreen.routeName, arguments: jsonEncode(filteredProducts[index]));
                                  // Navigator diguanakan untuk pindah kehalaman berikutnya yang menunjukan detai dari product list
                                },
                              )
                            ),
                          );
                        },
                      ),
                      //listview berfungsi untuk membuat sebuah tampilan dengan susunan vertikal dalam bentuk daftar(List) yang bisa di scroll.
                  ),
                  
                // else 
                  // Container(child: Text("No products"),)
              ],
            ),
      ),
    );
  }
}
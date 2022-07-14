import 'package:flutter/material.dart';
import 'package:shopapp/models/http_exception.dart';
import 'products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: '1',
        title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops",
        price: 109.95,
        description:
            "Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday",
        ImageUrl: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg"),
    Product(
      id: '2',
      title: "Mens Casual Premium Slim Fit T-Shirts ",
      price: 22.33,
      description:
          "Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing. And Solid stitched shirts with round neck made for durability and a great fit for casual fashion wear and diehard baseball fans. The Henley style round neckline includes a three-button placket.",
      ImageUrl:
          "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg",
    ),
    Product(
      id: '3',
      title: "Mens Cotton Jacket",
      price: 55.99,
      description:
          "great outerwear jackets for Spring/Autumn/Winter, suitable for many occasions, such as working, hiking, camping, mountain/rock climbing, cycling, traveling or other outdoors. Good gift choice for you or your family member. A warm hearted love to Father, husband or son in this thanksgiving or Christmas Day.",
      ImageUrl: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
    ),
    Product(
      id: '4',
      title: "Mens Casual Slim Fit",
      price: 15.99,
      description:
          "The color could be slightly different between on the screen and in practice. / Please note that body builds vary by person, therefore, detailed size information should be reviewed below on the product description.",
      ImageUrl: "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
    )
  ];

  List<Product> get item {
    // if (_showFavoritesOnly) {
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // var _showFavoritesOnly = false;

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Future<void> addProduct(Product product) async {
    // _items.add(value);
    final url = Uri.parse(
        'https://shopapp-d260c-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'ImageUrl': product.ImageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          ImageUrl: product.ImageUrl,
          id: json.decode(response.body)['name']);
      _items.add(newProduct);
      // _items.insert(0, newProduct); //start of list

      notifyListeners();
    } catch (error) {
      print(error);
      //   throw error;
    }
    //     .then((response) {
    //   print(json.decode(response.body));
    //   print(product.ImageUrl);

    // }).catchError((error) {
    //
    // });
    // const url = 'https://shopapp-d260c-default-rtdb.firebaseio.com/';
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shopapp-d260c-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            ImageUrl: prodData['ImageUrl'],
            isFavorite: prodData['isFavorite']));
      });
      _items = loadedProducts;
      print(response);
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopapp-d260c-default-rtdb.firebaseio.com/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'ImageUrl': newProduct.ImageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
    print('...');
  }

  Future<void> deeteProduct(String id) async {
    final url = Uri.parse(
        'https://shopapp-d260c-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('could not delete product');
    }
    existingProduct = null;
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}

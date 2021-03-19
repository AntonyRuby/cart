import 'package:flutter/cupertino.dart';

Cart cart = Cart();

class Cart extends ChangeNotifier {
  List<CartItem> items = [];

  void addToCart(item) {
    items.add(CartItem(
        item["id"], item["name"], item["img"], item["unit"], item["price"]));
    notifyListeners();
  }

  void increase(id) {
    CartItem i;
    for (i in items) {
      if (i.id == id) {
        i.quantity++;
        break;
      }
    }
    notifyListeners();
  }

  void decreace(id) {
    CartItem i;
    for (i in items) {
      if (i.id == id) {
        i.quantity--;
        if (i.quantity <= 0) {
          items.remove(i);
        }
        break;
      }
    }
    notifyListeners();
  }
}

class CartItem {
  final int id;
  final String name;
  final String unit;
  final String img;
  final int price;
  int quantity = 1;

  CartItem(this.id, this.name, this.img, this.unit, this.price);
}

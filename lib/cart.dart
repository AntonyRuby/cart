import 'package:cart/state.dart';
import 'package:flutter/material.dart';

class AddCart extends StatefulWidget {
  final items;
  AddCart({Key key, @required this.items}) : super(key: key);
  @override
  _AddCartState createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  int totalValue;

  @override
  Widget build(BuildContext context) {
    totalValue = 0;
    for (var i in cart.items) {
      totalValue += i.price * i.quantity;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          title: Text(
            "Cart",
            style: TextStyle(fontSize: 24),
          ),
        ),
        body: () {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart,
                    size: 256,
                  ),
                  Text(
                    "Cart is empty.",
                    style: TextStyle(fontSize: 24),
                  )
                ],
              ),
            );
          } else {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        CartItem cartItem = cart.items[index];
                        return Container(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/items_img/${cart.items[index].img}'),
                                      width: MediaQuery.of(context).size.width /
                                          3),
                                  Container(
                                      color: Colors.teal.shade300,
                                      child: (() {
                                        if (widget.items[index]["new"]) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'new',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          );
                                        }
                                      })()),
                                ]),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${cart.items[index].name}',
                                      style: TextStyle(fontSize: 22.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rs." '${cart.items[index].price}',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        Text("/" '${cart.items[index].unit}'),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    MaterialButton(
                                        minWidth: 8,
                                        onPressed: () {
                                          cart.decreace(cartItem.id);
                                          setState(() {});
                                        },
                                        child: Icon(Icons.remove)),
                                    Container(
                                      child: Text(
                                        cartItem.quantity.toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    MaterialButton(
                                      minWidth: 8,
                                      onPressed: () {
                                        cart.increase(cartItem.id);
                                        setState(() {});
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ],
                                )
                              ]),
                        ));
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Total Cart Value: $totalValue",
                    style: TextStyle(fontSize: 32),
                  ),
                )
              ],
            );
          }
        }());
  }
}

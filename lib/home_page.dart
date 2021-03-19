import 'package:cart/cart.dart';
import 'package:cart/state.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final items;
  HomePage({Key key, @required this.items}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          centerTitle: true,
          title: Text(
            "Shopping",
            style: TextStyle(fontSize: 24),
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddCart(items: widget.items)));
              },
              child: Stack(alignment: Alignment.topRight, children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 8, 0),
                  child: Icon(
                    Icons.shopping_cart,
                    size: 40,
                  ),
                ),
                () {
                  if (cart.items.isNotEmpty) {
                    return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red.shade300),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(cart.items.length.toString()),
                        ));
                  } else {
                    return Container();
                  }
                }()
              ]),
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: widget.items.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(children: [
                      Image(
                          image: AssetImage(
                              'assets/items_img/${widget.items[index]["img"]}'),
                          width: MediaQuery.of(context).size.width / 4),
                      Container(
                          color: Colors.teal.shade300,
                          child: (() {
                            if (widget.items[index]["new"]) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  'new',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            }
                          })()),
                    ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.items[index]["name"]}',
                          style: TextStyle(fontSize: 22.0),
                        ),
                        Row(
                          children: [
                            Text(
                              "Rs." '${widget.items[index]["price"]}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text("/" '${widget.items[index]["unit"]}'),
                          ],
                        ),
                      ],
                    ),
                    () {
                      bool isInCart = false;
                      CartItem cartItem;
                      for (var i in cart.items) {
                        if (i.id == widget.items[index]["id"]) {
                          isInCart = true;
                          cartItem = i;
                          break;
                        }
                      }
                      if (isInCart) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        );
                      } else {
                        return MaterialButton(
                          onPressed: () {
                            cart.addToCart(widget.items[index]);
                            setState(() {});
                          },
                          color: Colors.red,
                          child: Text(
                            "ADD TO CART",
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }(),
                  ],
                ),
              ),
            );
          },
        ));
  }
}

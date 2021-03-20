import 'dart:convert';

import 'package:cart/state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddCart extends StatefulWidget {
  final items;
  AddCart({Key key, @required this.items}) : super(key: key);
  @override
  _AddCartState createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  int totalValue;
  int dateIndex = -1;
  int timeIndex = -1;
  String date = " ";

  Future<Map<String, dynamic>> getSlots() async {
    final url = "https://online.ajmanmarkets.ae/api/grocery_slot.php";
    final res = await http.get(Uri.parse(url));
    var slots = json.decode(res.body);
    return slots;
  }

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
                FutureBuilder(
                    future: getSlots(),
                    builder: (context, snapshot) {
                      if (snapshot.data == null) {
                        return SizedBox(
                          height: 1.0,
                        );
                      } else {
                        return Expanded(
                          flex: dateIndex >= 0 ? 2 : 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: snapshot.data["data"].length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        DateTime dt = DateTime.parse(snapshot
                                            .data["data"][index]["date"]);
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: InkWell(
                                            onTap: () {
                                              dateIndex = index;
                                              timeIndex = -1;
                                              date = " ";
                                              setState(() {});
                                            },
                                            child: Container(
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    color: index == dateIndex
                                                        ? Colors.orange.shade700
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.grey)),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Text(
                                                      DateFormat('EEE')
                                                          .format(dt),
                                                      style: TextStyle(
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            index == dateIndex
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                    Text(
                                                        DateFormat('d').format(
                                                            dt),
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index ==
                                                                    dateIndex
                                                                ? Colors.white
                                                                : Colors
                                                                    .black)),
                                                  ],
                                                )),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              () {
                                if (dateIndex >= 0) {
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot
                                              .data["data"][dateIndex]["time"]
                                              .length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            String st = snapshot.data["data"]
                                                    [dateIndex]["time"][index]
                                                ["start_time"];
                                            String et = snapshot.data["data"]
                                                    [dateIndex]["time"][index]
                                                ["end_time"];
                                            bool disable = snapshot.data["data"]
                                                        [dateIndex]["time"]
                                                    [index]["type"] ==
                                                "disabled";
                                            return InkWell(
                                              onTap: () {
                                                if (disable == false) {
                                                  timeIndex = index;
                                                  date =
                                                      "${snapshot.data['data'][dateIndex]['date']} $st-$et";
                                                  setState(() {});
                                                }
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Container(
                                                    width: 120,
                                                    decoration: BoxDecoration(
                                                        color: disable
                                                            ? Colors.grey
                                                            : (index ==
                                                                    timeIndex
                                                                ? Colors.orange
                                                                    .shade700
                                                                : Colors.white),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Colors.grey)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(
                                                          Icons.timer,
                                                          color: index ==
                                                                  timeIndex
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                        Text(
                                                          "$st-$et",
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: index ==
                                                                    timeIndex
                                                                ? Colors.white
                                                                : Colors.black,
                                                          ),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            );
                                          }),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }()
                            ],
                          ),
                        );
                      }
                    }),
                Expanded(
                  flex: 6,
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
                                          5),
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
                                      style: TextStyle(fontSize: 20.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Rs."
                                          '${cart.items[index].price}',
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        Text("/"
                                            '${cart.items[index].unit}'),
                                      ],
                                    ),
                                    Text(
                                      date,
                                      style: TextStyle(fontSize: 14),
                                    )
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

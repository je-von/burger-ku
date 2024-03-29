import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/item.dart';
import 'package:frontend/util/api.dart';
import 'package:frontend/util/helper.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartPageState();
  }
}

class CartPageState extends State<CartPage> {
  List<Item> _cartItems = [];

  _getAllCartItems() async {
    final response = await Api.request('get', 'carts');
    setState(() {
      if (response.statusCode == 200) {
        _cartItems = json
            .decode(response.body)['data']
            .map<Item>((e) => (Item.fromJson(e['item'])))
            .toList();
      }
    });
  }

  _getTotalPrice() {
    int total = 0;
    for (var i in _cartItems) {
      total += i.price;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _getAllCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_cartItems.isEmpty) {
            Helper.showSnackBar(context, 'Cart is empty!');
            return;
          }

          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Are you sure want to checkout?'),
              content: Text(
                  'Total: ${NumberFormat.currency(locale: 'ID').format(_getTotalPrice())} (${_cartItems.length} items)'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'OK');
                    final response = await Api.request(
                      'delete',
                      'carts/checkout',
                    );
                    if (!mounted) return;
                    if (response.statusCode == 200) {
                      Helper.showSnackBar(context, 'Checkout successful!');
                      _getAllCartItems();
                    } else {
                      Helper.showSnackBar(
                          context, json.decode(response.body)['message']);
                    }
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.grey.shade50,
        child: Icon(
          Icons.shopping_cart_checkout,
          color: Colors.green.shade400,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: _cartItems
            .map((e) => (Card(
                  elevation: 7,
                  shadowColor: Colors.grey.shade400,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                  child: ListTile(
                    leading: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 50,
                        maxWidth: 45,
                        minHeight: 50,
                        minWidth: 45,
                      ),
                      child: Image.network(
                        Api.backendUrl + e.imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(
                      '${e.name} - ${NumberFormat.currency(locale: 'ID').format(e.price)}',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red.shade300),
                      onPressed: () async {
                        final response = await Api.request(
                          'delete',
                          'carts',
                          body: {'item_id': '${e.id}'},
                        );
                        if (!mounted) return;
                        if (response.statusCode == 200) {
                          Helper.showSnackBar(
                              context, '${e.name} deleted from cart!');
                          _getAllCartItems();
                        } else {
                          Helper.showSnackBar(
                              context, json.decode(response.body)['message']);
                        }
                      },
                    ),
                  ),
                )))
            .toList(),
      ),
    );
  }
}

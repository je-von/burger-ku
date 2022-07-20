import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/item.dart';
import 'package:frontend/util/api.dart';
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

  _getAllItems() async {
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

  @override
  void initState() {
    super.initState();
    _getAllItems();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _cartItems
          .map((e) => (Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
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
                  trailing: const Icon(Icons.delete),
                ),
              )))
          .toList(),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/item.dart';
import 'package:frontend/util/api.dart';
import 'package:intl/intl.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemPageState();
  }
}

class ItemPageState extends State<ItemPage> {
  List<Item> _items = [];

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  _getAllItems() async {
    final response = await Api.request('get', 'items');
    setState(() {
      if (response.statusCode == 200) {
        _items = json
            .decode(response.body)['data']
            .map<Item>((e) => (Item.fromJson(e)))
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
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(10),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: _items
          .map((e) => (Card(
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 80,
                        maxWidth: 80,
                        minHeight: 80,
                        minWidth: 80,
                      ),
                      child: Image.network(
                        Api.backendUrl + e.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      e.name,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      NumberFormat.currency(locale: 'ID').format(e.price),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.fade,
                    ),
                    ElevatedButton(
                      child: const Text('Detail'),
                      onPressed: () => {},
                    ),
                  ],
                ),
              )))
          .toList(),
    );
  }
}

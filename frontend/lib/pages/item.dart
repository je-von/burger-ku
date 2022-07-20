import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/components/card.dart';
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
  List<Item> _filteredItems = [];
  List<String> _types = [];

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
        _filteredItems = _items;
      }
    });
  }

  _getAllTypes() async {
    final response = await Api.request('get', 'types');
    setState(() {
      if (response.statusCode == 200) {
        _types = json
            .decode(response.body)['data']
            .map<String>(
                (e) => (e['name'] is String ? e['name'] as String : ''))
            .toList();
        _types.insert(0, 'Filter');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllItems();
    _getAllTypes();
  }

  String _dropdownValue = 'Filter';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: DropdownButton<String>(
                value: _dropdownValue,
                items: _types.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _dropdownValue = value!;
                    if (value == 'Filter') {
                      _filteredItems = _items;
                    } else {
                      _filteredItems =
                          _items.where((i) => i.type == value).toList();
                    }
                    print(_filteredItems);
                  });
                },
                icon: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Icon(Icons.arrow_drop_down),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
                dropdownColor: Colors.white,
                underline: Container(),
                isExpanded: true,
              ),
            ),
          ),
          GridView.count(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.symmetric(vertical: 10),
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 2,
            children: _filteredItems
                .map(
                  (e) => (CardWidget(
                    image: Image.network(
                      Api.backendUrl + e.imagePath,
                      fit: BoxFit.cover,
                    ),
                    title: e.name,
                    subTitle:
                        NumberFormat.currency(locale: 'ID').format(e.price),
                    buttonTitle: 'Detail',
                    onButtonPressed: () => {},
                  )),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

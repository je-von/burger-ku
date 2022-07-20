import 'package:flutter/material.dart';
import 'package:frontend/pages/cart.dart';
import 'package:frontend/pages/home.dart';
import 'package:frontend/pages/item.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/util/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeContainerState();
  }
}

class HomeContainerState extends State<HomeContainer> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<String> _titles = <String>[
    'Home',
    'Menu',
    'My Carts',
  ];
  final List<Widget> _widgets = <Widget>[
    const HomePage(),
    const ItemPage(),
    const CartPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return ['Logout'].map((e) {
              return PopupMenuItem(
                child: TextButton(
                  child: Row(
                    children: [
                      const Icon(Icons.logout_rounded),
                      Text(e),
                    ],
                  ),
                  onPressed: () async {
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    if (await preferences.remove('auth_token')) {
                      if (!mounted) return;
                      Helper.redirect(context, const LoginPage(),
                          removeHistory: true);
                    }
                  },
                ),
              );
            }).toList();
          })
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange.shade800,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_sharp),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            activeIcon: Icon(Icons.fastfood),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: '',
          ),
        ],
      ),
      body: _widgets[_selectedIndex],
    );
  }
}

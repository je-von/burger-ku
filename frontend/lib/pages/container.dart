import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 40),
            child: Text(
              'Welcome to BurgerKu!',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide()),
            ),
          ),
          Text(
            'Events & Promotions',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
          ),
          // CarouselSlider(
          //   items: globals.carouselImages
          //       .map((c) => Image(
          //             image: AssetImage(c),
          //           ))
          //       .toList(),
          //   options: CarouselOptions(
          //       autoPlayCurve: Curves.fastLinearToSlowEaseIn,
          //       autoPlay: true,
          //       enableInfiniteScroll: true,
          //       scrollDirection: Axis.horizontal,
          //       enlargeCenterPage: true,
          //       autoPlayInterval: Duration(seconds: 2)),
          // ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 40),
            decoration: BoxDecoration(
              border: Border(top: BorderSide()),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Image.asset('assets/logo.png'),
                      ),
                    ),
                    Text(
                      'About Us',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
                    )
                  ],
                ),
                Text(
                  'Lorem ipsum dolor sit amet consectetur adipisicing elit. Asperiores distinctio eveniet laborum! Nihil rerum perferendis dolorem. Perferendis a nesciunt possimus molestiae earum id, autem quae soluta porro sunt nam at. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Praesentium voluptas maxime vitae, distinctio quidem cum architecto optio quisquam deserunt facilis nam necessitatibus placeat iure animi. Sint rem inventore excepturi quisquam. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Libero dicta debitis quae quam ducimus quidem error, cupiditate natus, quis corporis ratione suscipit eius pariatur tempore laboriosam nulla totam, earum culpa!',
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(30),
            child: Text(
              '©2022',
              style: TextStyle(fontStyle: FontStyle.italic),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

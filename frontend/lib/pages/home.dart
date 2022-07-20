import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/logo.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const _images = [
    'assets/carousel/1.png',
    'assets/carousel/2.jpg',
    'assets/carousel/3.jpg',
    'assets/carousel/4.jpg',
    'assets/carousel/5.jpg',
    'assets/carousel/6.jpg',
    'assets/carousel/7.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: const [
              Text(
                'Welcome to',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              LogoWidget()
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 40),
          decoration: const BoxDecoration(
            border: Border.symmetric(horizontal: BorderSide()),
          ),
          child: Column(
            children: const [
              Text(
                'About Us',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
              ),
              Text(
                "BurgerKu's Corporation is an Indonesian-based multinational fast food chain, founded in 1940 as a restaurant operated by JV, in Jakarta, Indonesia. They rechristened their business as a hamburger stand, and later turned the company into a franchise, with the Golden Arches logo being introduced in 1953 at a location in Phoenix, Arizona. In 1955, Ray Kroc, a businessman, joined the company as a franchise agent and proceeded to purchase the chain from the BurgerKu brothers. BurgerKu's had its previous headquarters in Oak Brook, Illinois, but moved its global headquarters to Chicago in June 2018.\n\nBurgerKu's is the world's largest restaurant chain by revenue, serving over 69 million customers daily in over 100 countries across 37,855 outlets as of 2018. BurgerKu's is best known for its hamburgers, cheeseburgers and french fries, although their menus include other items like chicken, fish, fruit, and salads. The company has been the recipient of negative backlash because of the unhealthiness of their food. The BurgerKu's Corporation revenues come from the rent, royalties, and fees paid by the franchisees, as well as sales in company-operated restaurants. According to two reports published in 2018, BurgerKu's is the world's second-largest private employer with 1.7 million employees (behind Walmart with 2.3 million employees). As of 2020, BurgerKu's has the ninth-highest global brand valuation.",
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
        const Text(
          'Events & Promotions',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        CarouselSlider(
          items: _images
              .map(
                (i) => Image(
                  image: AssetImage(i),
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            autoPlay: true,
            enableInfiniteScroll: true,
            scrollDirection: Axis.horizontal,
            enlargeCenterPage: true,
            autoPlayInterval: const Duration(seconds: 2),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(30),
          child: const Text(
            '© 2022 by JV',
            style: TextStyle(fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

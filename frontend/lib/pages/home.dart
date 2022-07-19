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
                'Lorem ipsum dolor sit amet consectetur adipisicing elit. Asperiores distinctio eveniet laborum! Nihil rerum perferendis dolorem. Perferendis a nesciunt possimus molestiae earum id, autem quae soluta porro sunt nam at. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Praesentium voluptas maxime vitae, distinctio quidem cum architecto optio quisquam deserunt facilis nam necessitatibus placeat iure animi. Sint rem inventore excepturi quisquam. Lorem, ipsum dolor sit amet consectetur adipisicing elit. Libero dicta debitis quae quam ducimus quidem error, cupiditate natus, quis corporis ratione suscipit eius pariatur tempore laboriosam nulla totam, earum culpa!',
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

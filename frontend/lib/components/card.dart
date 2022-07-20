import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final Image image;
  final String title;
  final String subTitle;
  final String buttonTitle;
  final void Function() onButtonPressed;

  const CardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.buttonTitle,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 7,
      shadowColor: Colors.grey.shade400,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 80,
              maxWidth: 80,
              minHeight: 80,
              minWidth: 80,
            ),
            child: image,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            overflow: TextOverflow.fade,
          ),
          ElevatedButton(
            onPressed: onButtonPressed,
            child: Text(buttonTitle),
          ),
        ],
      ),
    );
  }
}

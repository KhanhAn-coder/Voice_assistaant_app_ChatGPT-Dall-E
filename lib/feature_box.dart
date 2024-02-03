import 'package:flutter/material.dart';
import 'package:voice_assistance_app/pallete.dart';

class FeatureBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String descriptionText;
  const FeatureBox({super.key, required this.color, required this.headerText, required this.descriptionText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration:  BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: color,
      ),
      child:  Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              headerText,
              style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 18,
                  color: Pallete.blackColor,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(height: 3,),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              descriptionText,
              style: const TextStyle(
                  fontFamily: 'Cera Pro',
                  fontSize: 13,
                  color: Pallete.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

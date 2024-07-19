import 'package:flutter/material.dart';
import 'constants.dart';

class CardBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: PlayingCardWidth,
      height: PlayingCardHeight,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(3),
          ),

          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 3.5, // Vertical spacing
              crossAxisSpacing: 2.0, // Horizontal spacing
            ),
            itemBuilder: (context, index) {
              return const Center(
                child: Text(
                  "◆",
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 6, // Adjust size as needed
                  ),
                ),
              );
            },
            itemCount: 35, // Adjust the number of items
          ),
        ),
      ),
    );
  }
}
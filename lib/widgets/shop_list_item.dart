import 'package:flutter/material.dart';

class ShopListItem extends StatelessWidget {
  const ShopListItem({
    super.key,
    required this.itemWidget,
    required this.itemName,
    required this.price,
    required this.onTap,
  });

  final Widget itemWidget;
  final String itemName;
  final int price;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   colors: rankColorGradient(userRank),
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
        color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5.0,
              spreadRadius: 0.0,
              offset: const Offset(0, 1),
            )
          ]
      ),
      child: Material(
        child: InkWell(
          onTap: this.onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: this.itemWidget,
              ),
              Text(
                '${this.itemName}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontSize: 16,
                ),
              ),
              Text(
                '💎 ${this.price}',
                style: TextStyle(
                  color: Colors.black.withOpacity(0.75),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        color: Colors.transparent,
      ),
    );
  }
}
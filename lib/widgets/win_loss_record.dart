import 'package:flutter/material.dart';

class WinLossRecord extends StatelessWidget {
  WinLossRecord({
    super.key,
    required this.win,
    required this.loss,
    required this.draw,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.boxColor = Colors.transparent,
  });

  final int win, loss, draw;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color boxColor;

  @override
  build(BuildContext context) {
    return Container(
      margin: this.margin,
      padding: this.padding,
      decoration: BoxDecoration(
        color: this.boxColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[
          TableRow(
            children: <Center>[
              Center(child: Text(
                'WIN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF428BCA),
                ),
              )),
              Center(child: Text(
                'LOSE',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9534F),
                ),
              )),
              Center(child: Text(
                'DRAW',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888),
                ),
              )),
            ],
          ),
          TableRow(
            children: <Center>[
              Center(child: Text(
                '${this.win}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF428BCA),
                ),
              )),
              Center(child: Text(
                '${this.loss}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9534F),
                ),
              )),
              Center(child: Text(
                '${this.draw}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF888888),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }
}
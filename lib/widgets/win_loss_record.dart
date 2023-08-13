import 'package:flutter/material.dart';

class WinLossRecord extends StatefulWidget {
  const WinLossRecord({
    super.key,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.boxColor = Colors.transparent,
  });

  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final Color boxColor;

  @override
  State<WinLossRecord> createState() => _WinLossRecordState();
}

class _WinLossRecordState extends State<WinLossRecord> {
  @override build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.boxColor,
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
                '0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF428BCA),
                ),
              )),
              Center(child: Text(
                '0',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD9534F),
                ),
              )),
              Center(child: Text(
                '0',
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
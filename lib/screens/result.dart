import 'package:flutter/material.dart';
import '../widgets/profile_image.dart';
import '../widgets/win_loss_record.dart';

class Result extends StatelessWidget {
  const Result({super.key, required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: this.result == 'win'?
                [Color(0xFF428BCA), Color(0xFFD6E7F6)]
              : this.result == 'lose' ?
                [Color(0xFFD9534F), Color(0xFFFAD6D5)]
              : this.result == 'draw' ?
                [Color(0xFF888888), Color(0xFFE7E7E7)]
              : [Color(0xFFFFFFFF)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ProfileImage(
                url: '',
                width: 64,
                height: 64,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  '@UserName',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '✊',
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  this.result == 'win'? 'YOU WIN' : this.result == 'lose' ? 'YOU LOSE' : this.result == 'draw' ? 'DRAW' : '',
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '🖐️',
                style: TextStyle(
                  fontSize: 48,
                ),
              ),
              WinLossRecord(
                win: 0,
                loss: 0,
                draw: 0,
                padding: EdgeInsets.all(16),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person_add, size: 48, color: Colors.black.withOpacity(0.5)),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.exit_to_app_rounded, size: 48, color: Colors.black.withOpacity(0.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
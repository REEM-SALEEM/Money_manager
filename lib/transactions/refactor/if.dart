import 'package:flutter/material.dart';
class EleButton extends StatefulWidget {
  final String monthname;
   final Future<dynamic> functname;
  const EleButton({super.key, required this.monthname, required this.functname});

  @override
  State<EleButton> createState() => EelBbuttonState();
}

class EelBbuttonState extends State<EleButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
        ),
        onPressed: () {
          setState(() {
          widget.functname;
          });
        },
        child: Text(widget.monthname));
  }
}

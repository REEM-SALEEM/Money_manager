import 'package:flutter/material.dart';

Future<void> aboutPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder: ((context) {
      return SimpleDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'ABOUT',
            style: TextStyle(color: Colors.white),
          ),
          children: [
            const Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. ',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(180, 0, 0, 0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ]);
    }),
  );
}

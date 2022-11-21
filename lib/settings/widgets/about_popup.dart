import 'package:flutter/material.dart';

Future<void> aboutPopup(BuildContext context) async {
  showDialog(
    context: context,
    builder: ((context) {
      return SimpleDialog(backgroundColor: Colors.black, children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const SizedBox(width: 16),
          SizedBox(
            width: 65,
            height: 65,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/1.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              const Text(
                ' Croupier',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              const SizedBox(height: 3),
              // ignore: prefer_const_constructors
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Center(
                    child: Text(
                  'Version 1.0.1',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )),
              ),
              const SizedBox(height: 15),
              Row(
                children: const [
                  Icon(
                    Icons.copyright_outlined,
                    color: Colors.grey,
                    size: 15,
                  ),
                  Text(
                    ' 2022 company',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ],
          )
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(180, 17, 0, 0),
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

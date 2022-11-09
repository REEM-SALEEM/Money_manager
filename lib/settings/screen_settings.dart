import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/settings/widgets/about_popup.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/transaction/transaction_db.dart';

class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  var vals = false;
  var vals1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 100, 0, 40),
              child: Text(
                'SETTINGS',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 7.0,
                      offset: Offset(6.0, 6.0),
                    )
                  ],
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                  iconColor: Colors.white,
                  title: const Text(
                    'Reset App',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  trailing: Switch(
                    value: vals,
                    onChanged: (value) {
                      setState(() {
                        vals = value;
                        if (value == true) {
                          resetPopup(context);
                        } else {
                          value == false;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 7.0,
                      offset: Offset(6.0, 6.0),
                    )
                  ],
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                padding: const EdgeInsets.all(10),
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    size: 30,
                  ),
                  iconColor: Colors.white,
                  title: const Text('Reminders',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                  trailing: Switch(
                    value: vals1,
                    onChanged: (value) {
                      setState(() {
                        vals1 = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: vals1 == false ? false : true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 14, 0, 0),
                child: Container(
                  height: 70,
                  width: 364,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 7.0,
                        offset: Offset(6.0, 6.0),
                      )
                    ],
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  padding: const EdgeInsets.all(7),
                  child: const ListTile(
                    leading: Icon(
                      Icons.timelapse,
                      size: 30,
                    ),
                    iconColor: Colors.black,
                    title: Text(
                      'Set Timer',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: InkWell(
                onTap: () {
                  aboutPopup(context);
                },
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 7.0,
                        offset: Offset(6.0, 6.0),
                      )
                    ],
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const ListTile(
                    leading: Icon(
                      Icons.info_outline,
                      size: 30,
                    ),
                    iconColor: Colors.white,
                    title: Text(
                      'About',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 250),
            const Center(
              child: Text(
                'Version 1.0.1',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  resetPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Center(
              child: Text(
                'Reset',
                style: TextStyle(color: Colors.white),
              ),
            ),
            children: [
              const Center(
                child: Text(
                  'Are you sure you want to reset app?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          clearAppData();
                        },
                        child: const Text('yes')),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop(context);
                            vals = false;
                          });
                        },
                        child: const Text('Cancel')),
                  ],
                ),
              )
            ]);
      }),
    );
  }

  Future<void> clearAppData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear;
    await TransactionDB.instance.transactionClear();
    await CategoryDB.instance.categoryClear();
    Restart.restartApp();
  }
}

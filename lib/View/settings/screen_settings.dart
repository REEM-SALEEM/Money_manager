import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_resetapp.dart';
import 'package:money_manager/Controller/provider/prov_visibility.dart';
import 'package:money_manager/View/settings/widgets/about_popup.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ScreenSetting extends StatelessWidget {
  ScreenSetting({super.key});

  var vals = false;
  var vals1 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 41, 41),
      body: Column(
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
            child: InkWell(
              onTap: () {
                resetPopup(context);
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
                    Icons.refresh,
                    size: 30,
                  ),
                  iconColor: Colors.white,
                  title: Text(
                    'Reset App',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
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
              child: Consumer<ProvSwitch>(
                builder: (BuildContext context, swi, Widget? child) {
                  return ListTile(
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
                        vals1 = value;
                        swi.indexTab = vals1;
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Consumer<ProvSwitch>(
            builder: (BuildContext context, value, Widget? child) {
              return Visibility(
                visible: vals1 == false ? false : true,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(13, 14, 0, 0),
                  child: Container(
                    height: 70,
                    width: 93.w,
                    // width: 364,
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
                    padding: const EdgeInsets.fromLTRB(10, 7, 7, 7),
                    child: ListTile(
                      onTap: () async {
                        await Provider.of<ProvTimepicker>(context,
                                listen: false)
                            .timePicked(context);
                        // await timePicked(context);
                      },
                      leading: const Icon(
                        Icons.timelapse,
                        size: 32,
                      ),
                      iconColor: Colors.black,
                      title: const Text(
                        'Set Timer',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
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
          const SizedBox(height: 180),
          const Center(
            child: Text(
              'Version 1.0.1',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

//*Reset popup
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
                  'Are you sure to reset app?',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 8),
                      ),
                      onPressed: () {
                        Provider.of<Reset>(context, listen: false)
                            .clearAppData(context);
                      },
                      child: const Text('Yes')),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 8),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(context);
                        vals = false;
                      },
                      child: const Text('No')),
                ],
              )
            ]);
      }),
    );
  }
}

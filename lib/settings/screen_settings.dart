import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screen_navbar.dart';
import 'package:money_manager/settings/widgets/about_popup.dart';
import 'package:money_manager/settings/widgets/schedule_reminder.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../db/transaction/transaction_db.dart';
import 'package:sizer/sizer.dart';


class ScreenSetting extends StatefulWidget {
  const ScreenSetting({super.key});

  @override
  State<ScreenSetting> createState() => _ScreenSettingState();
}

class _ScreenSettingState extends State<ScreenSetting> {
  var vals = false;
  var vals1 = false;
  static TimeOfDay initialTime = TimeOfDay.now();
  @override
  void initState() {
    super.initState();
    NotificationApi().init(initScheduled: true);
  }

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
                    await timePicked(context);
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
           const SizedBox(height: 25),
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
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          clearAppData();
                        },
                        child: const Text('Yes')),
                  ),
                  SizedBox(
                    width: 80,
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.of(context).pop(context);
                            vals = false;
                          });
                        },
                        child: const Text('Cancel')),
                  ),
                ],
              )
            ]);
      }),
    );
  }

  timePicked(BuildContext context) async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (newTime == null) {
      return;
    } else {
      NotificationApi.showScheduledNotifications(
        body: "It's time to stay on track.",
        scheduledTime: Time(newTime.hour, newTime.minute, 0),
        payload: 'Reminder',
      );
    }
    if (mounted) {
      showTopSnackBar(
        context,
        const CustomSnackBar.success(
          message: "Reminder set successfully ",
        ),
      );
    }
  }

  void listenNotifications() {
    NotificationApi.onNotifications.listen(onClickedNotification);
  }

  onClickedNotification(String? payload) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const BottomNavigationScreen()));
  }

//*Reset
  Future<void> clearAppData() async {
    //clear shared preference
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear;
    //clear transaction and category
    await TransactionDB.instance.transactionClear();
    await CategoryDB.instance.categoryClear();
    Restart.restartApp();
  }
}

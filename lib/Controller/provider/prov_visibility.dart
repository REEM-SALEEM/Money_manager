import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:money_manager/Controller/provider/schedule_reminder.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../View/screen_navbar.dart';

class ProvSwitch extends ChangeNotifier {
  //----------------------------------------------------Switch
  bool? selectedindexTab;
  get indexTab => selectedindexTab;
  set indexTab(value) {
    selectedindexTab = value;
    notifyListeners();
  }
}

class ProvTimepicker extends ChangeNotifier {
  static TimeOfDay initialTime = TimeOfDay.now();
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

    showTopSnackBar(
      context,
      const CustomSnackBar.success(
        message: "Reminder set successfully ",
      ),
    );
  }

  dynamic listenNotifications(context) {
    NotificationApi.onNotifications
        .listen(onClickedNotification('Reminder', context));
  }

  onClickedNotification(String? payload, BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
  }
}

import 'package:flutter/cupertino.dart';
import 'package:money_manager/Controller/provider/prov_categoryfunctions.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Reset extends ChangeNotifier {
  Future<void> clearAppData(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear;
    Provider.of<ProvTransactionDB>(context, listen: false).transactionClear();
    Provider.of<ProvCategoryDB>(context, listen: false).categoryClear();
    Restart.restartApp();
  }
}

//  @override
//   void initState() {
//     super.initState();
//     NotificationApi().init(initScheduled: true);
//   }
// static TimeOfDay initialTime = TimeOfDay.now();
//-------------------------------------------------------------------------Visibility (Switch)

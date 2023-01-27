import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/Controller/provider/prov_addbutton.dart';
import 'package:money_manager/Controller/provider/prov_bottom.dart';
import 'package:money_manager/Controller/provider/prov_chart.dart';
import 'package:money_manager/Controller/provider/prov_checklogin.dart';
import 'package:money_manager/Controller/provider/prov_dateparsing.dart';
import 'package:money_manager/Controller/provider/prov_filter.dart';
import 'package:money_manager/Controller/provider/prov_resetapp.dart';
import 'package:money_manager/Controller/provider/prov_tot.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:money_manager/Model/model/category/category_model.dart';
import 'package:money_manager/Model/model/transaction/transaction_model.dart';
import 'package:money_manager/View/screen_splash.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'Controller/provider/prov_categoryfunctions.dart';
import 'Controller/provider/prov_sharedpreference.dart';
import 'Controller/provider/prov_visibility.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }
  if (!Hive.isAdapterRegistered(TransactionModelAdapter().typeId)) {
    Hive.registerAdapter(TransactionModelAdapter());
  }
  tz.initializeTimeZones();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) {
    runApp(
      const MyApp(),
    );
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => BottomProvider()),
            ChangeNotifierProvider(create: (context) => ProvCategoryDB()),
            ChangeNotifierProvider(create: (context) => ProvFloating()),
            ChangeNotifierProvider(create: (context) => ProvPopup()),
            ChangeNotifierProvider(create: (context) => ProvTransactionDB()),
            ChangeNotifierProvider(create: (context) => ProvTRadio()),
            ChangeNotifierProvider(create: (context) => ProvTCalender()),
            ChangeNotifierProvider(create: (context) => ProvTCategory()),
            ChangeNotifierProvider(create: (context) => ProvTCategorytype()),
            ChangeNotifierProvider(create: (context) => ProvChart()),
            ChangeNotifierProvider(create: (context) => Filter()),
            ChangeNotifierProvider(create: (context) => FilterAll()),
            ChangeNotifierProvider(create: (context) => Incchart()),
            ChangeNotifierProvider(create: (context) => Total()),
            ChangeNotifierProvider(create: (context) => Expchart()),
            ChangeNotifierProvider(create: (context) => ProvLogin()),
            ChangeNotifierProvider(create: (context) => ProvGetnSet()),
            ChangeNotifierProvider(create: (context) => ProvParse()),
            ChangeNotifierProvider(create: (context) => Reset()),
            ChangeNotifierProvider(create: (context) => ProvSwitch()),
            ChangeNotifierProvider(create: (context) => ProvTimepicker()),
            ChangeNotifierProvider(create: (context) => ProvAddButton()),
          ],
          child: MaterialApp(
            theme: ThemeData(
              primarySwatch: Colors.lightGreen,
            ),
            debugShowCheckedModeBanner: false,
            home: const ScreenSplash(),
          ),
        );
      },
    );
  }
}

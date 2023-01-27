import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_filter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
import '../../../Controller/provider/prov_categoryfunctions.dart';
import '../../../Controller/provider/prov_transactions.dart';
import '../../../Model/model/category/category_model.dart';
import '../refactor/card_refactor.dart';

class TransactionList extends StatelessWidget {
  TransactionList({super.key});

  List<String> monthsList = [
    "JAN",
    "FEB",
    "MAR",
    "APR",
    "MAY",
    "JUN",
    "JUL",
    "AUG",
    "SEP",
    "OCT",
    "NOV",
    "DEC"
  ];
  List<String> parameter = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12'
  ];
  Map<int, bool> boollist = {
    0: false,
    1: false,
    2: false,
    3: false,
    4: false,
    5: false,
    6: false,
    7: false,
    8: false,
    9: false,
    10: false,
    11: false,
    12: false
  };
// TransactionModel? dat;
// DateTimeRange? newRange;
// DateTimeRange? picked;
// DateTime? startDate;
// DateTime? endDate;

  String dp = 'Overall';
  List<String> catee = ['Overall', 'Income', 'Expense'];

  String datefiltration = 'All';
  List<String> items = ['All', 'Today', 'Yesterday', 'Month', 'Custom'];

  @override
  Widget build(BuildContext context) {
    Provider.of<ProvTransactionDB>(context, listen: false).refresh();
    Provider.of<ProvCategoryDB>(context, listen: false).refreshUI();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvTransactionDB>(context, listen: false)
          .incometransactionListNotifier;
      Provider.of<ProvTransactionDB>(context, listen: false)
          .expensetransactionListNotifier;
      Provider.of<ProvTransactionDB>(context, listen: false).filterListNotifier;
      Provider.of<ProvTransactionDB>(context, listen: false)
          .transactionListNotifier;
    });

    // DateTime now = DateTime.now();
    // final today = DateTime(now.year, now.month, now.day);
    // final yesterday = DateTime(now.year, now.month, now.day - 1);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: const Text('TRANSACTIONS',
              style: TextStyle(color: Colors.white, fontSize: 17)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        body: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            //----Category Drop down button
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.lightGreen),
                //--------------------------------------------------------------OverAll #1
                child: Consumer<Filter>(
                  builder: (BuildContext context, filtr, Widget? _) {
                    return DropdownButton<String>(
                      underline: Column(),
                      value: dp,
                      onChanged: (value) async {
                        dp = value!;
                        filtr.selectedCategorytype = dp;
                        Provider.of<ProvTransactionDB>(context, listen: false)
                            .filterCategory(dp);
                      },
                      items: catee.map<DropdownMenuItem<String>>((catee) {
                        return DropdownMenuItem(
                          value: catee,
                          child: Text(
                            " $catee",
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              width: 2.w,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
              child: Consumer<ProvTransactionDB>(
                builder: (BuildContext context, va, Widget? child) {
                  return Container(
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightGreen),
                    //----------------------------------------------------------------All #2
                    child: Consumer2<FilterAll, ProvTransactionDB>(
                      builder: (BuildContext context, value1, tra, Widget? _) {
                        return DropdownButton<String>(
                          underline: Column(),
                          value: datefiltration,
                          onChanged: (String? value) {
                            datefiltration = value!;
                            value1.selectedCategorytype = datefiltration;
                            Provider.of<ProvTransactionDB>(context,
                                    listen: false)
                                .filterList(datefiltration, context);
                            datefiltration == 'Custom'
                                ? Provider.of<ProvTransactionDB>(context,
                                        listen: false)
                                    .selectDate(context)
                                : Provider.of<ProvTransactionDB>(context,
                                        listen: false)
                                    .filterList(datefiltration, context);
                          },
                          items: items.map<DropdownMenuItem<String>>((items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(
                                " $items",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ]),
          Consumer<FilterAll>(
            builder: (BuildContext context, value1, Widget? child) {
              return Visibility(
                  visible: value1.selectedCategorytype == 'Month'
                      ? true
                      : true == false,
                  child: SizedBox(
                    height: 80,
                    child: Consumer<ProvTransactionDB>(
                        builder: (BuildContext ctx, newList, Widget? _) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 6),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: boollist[index]!
                                            ? Colors.orange
                                            : Colors.lightGreen),
                                    onPressed: () async {
                                      boollist[index] = true;
                                      await Provider.of<ProvTransactionDB>(
                                              context,
                                              listen: false)
                                          .sortedMonth(parameter[index]);
                                      // sortedMonth(parameter[index]);

                                      boollist.forEach((k, v) {
                                        if (index != k) {
                                          boollist[k] = false;
                                        }
                                      });
                                    },
                                    child:
                                        Text(monthsList[index].toUpperCase())),
                                const SizedBox(width: 5),
                              ]);
                        },
                        itemCount: monthsList.length,
                      );
                    }),
                  ));
            },
          ),
          Expanded(child: Consumer2<FilterAll, ProvTransactionDB>(builder:
              (BuildContext ctx, FilterAll value1, newList, Widget? _) {
            print(datefiltration);
            return newList.transactionListNotifier.isEmpty
                ? Center(
                    child: Lottie.asset("assets/lottie/629-empty-box.json"),
                  )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final value = newList.transactionListNotifier[index];
//  if (value1.selectedCategorytype == "Month" && value.date == DateTime.now()) {
//                         return CardRefactor(
//                           date: value.date,
//                           amount: value.amount,
//                           catname: value.category.name,
//                           id: value.id,
//                           valueedit: value,
//                           indexedit: index,
//                           type: value.type,
//                         );
//                       }
                      if (datefiltration == 'Yesterday' &&
                          value.date.day == DateTime.now().day - 1) {
                        print(value.date.day);
                        return CardRefactor(
                          date: value.date,
                          amount: value.amount,
                          catname: value.category.name,
                          id: value.id,
                          valueedit: value,
                          indexedit: index,
                          type: value.type,
                        );
                      }
                      if (dp == 'Expense' &&
                          value.type == CategoryType.expense) {
                        return CardRefactor(
                          date: value.date,
                          amount: value.amount,
                          catname: value.category.name,
                          id: value.id,
                          valueedit: value,
                          indexedit: index,
                          type: value.type,
                        );
                      }
                      if (dp == 'Overall') {
                        return CardRefactor(
                          date: value.date,
                          amount: value.amount,
                          catname: value.category.name,
                          id: value.id,
                          valueedit: value,
                          indexedit: index,
                          type: value.type,
                        );
                      }
                      return Column();
                    },
                    itemCount: newList.transactionListNotifier.length);
          }))
        ]),
      ),
    );
  }
}

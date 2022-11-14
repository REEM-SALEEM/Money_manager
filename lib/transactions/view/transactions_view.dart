import 'package:flutter/material.dart';
import 'package:money_manager/transactions/refactor/card_refactor.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

TransactionModel? dat;
DateTimeRange? newRange;
DateTimeRange? picked;
DateTime? startDate;
DateTime? endDate;

String dp = 'Overall';
List<String> catee = ['Overall', 'Income', 'Expense'];

String dropdownValue = 'All';
List<String> items = ['All', 'Today', 'Yesterday', 'Month', 'Custom'];

class _TransactionListState extends State<TransactionList> {
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    TransactionDB.instance.refresh();
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
          body: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                //----Category Drop down button
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black),
                    child: DropdownButton<String>(
                      underline: Column(),
                      //Initially 'Overall'
                      value: dp,
                      onChanged: (value) async {
                        setState(
                          () {
                            dp = value!;
                            TransactionDB.instance.filterCategory(dp);
                          },
                        );
                      },
                      items: catee.map<DropdownMenuItem<String>>((catee) {
                        return DropdownMenuItem(
                          value: catee,
                          child: Text(
                            " $catee",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w900),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.lightGreen),
                    //----Dropdown Button
                    child: DropdownButton<String>(
                      underline: Column(),
                      //Initially 'All'
                      value: dropdownValue,
                      onChanged: (String? value) async {
                        setState(
                          () {
                            dropdownValue = value!;

                            dropdownValue == 'Custom'
                                ? _selectDate(context)
                                : TransactionDB.instance
                                    .filterList(dropdownValue);
                            TransactionDB.instance.filterList(dropdownValue);
                          },
                        );
                      },
                      items: items.map<DropdownMenuItem<String>>((items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(" $items"),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ]),
              Visibility(
                  visible: dropdownValue == 'Month' ? true : true == false,
                  child: SizedBox(
                    height: 80,
                    child: ValueListenableBuilder(
                        valueListenable:
                            TransactionDB.instance.transactionListNotifier,
                        builder: (BuildContext ctx,
                            List<TransactionModel> newList, Widget? _) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('1');
                                          });
                                        },
                                        child: const Text('JAN')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('2');
                                          });
                                        },
                                        child: const Text('FEB')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('3');
                                          });
                                        },
                                        child: const Text('MAR')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('4');
                                          });
                                        },
                                        child: const Text('APR')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('5');
                                          });
                                        },
                                        child: const Text('MAY')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('6');
                                          });
                                        },
                                        child: const Text('JUNE')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('7');
                                          });
                                        },
                                        child: const Text('JULY')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('8');
                                          });
                                        },
                                        child: const Text('AUG')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            sortedMonth('9');
                                          });
                                        },
                                        child: const Text('SEP')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            sortedMonth('10');
                                          });
                                        },
                                        child: const Text('OCT')),
                                    const SizedBox(width: 6),
                                    ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            sortedMonth('11');
                                          });
                                        },
                                        child: const Text('NOV')),
                                    const SizedBox(width: 6),
                                    // Text(mon.date.month.toString()),
                                    ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            sortedMonth('12');
                                          });
                                        },
                                        child: const Text('DEC')),
                                    const SizedBox(width: 6),
                                  ]);
                            },
                            itemCount: 1,
                          );
                        }),
                  )),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: dropdownValue == 'All'
                      ? TransactionDB.instance.transactionListNotifier
                      : TransactionDB.instance.filterListNotifier,
                  builder: (BuildContext ctx, List<TransactionModel> newList,
                      Widget? _) {
                    return ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final value = newList[index];

                          if (dp == 'Income' &&
                              value.type == CategoryType.income) {
                            return CardRefactor(
                              date: value.date,
                              amount: value.amount,
                              catname: value.category.name,
                              id: value.id,
                              valueedit: value,
                              indexedit: index,
                              type: value.type,
                            );
                          } else if (dp == 'Expense' &&
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
                          } else if (dp == 'Overall') {
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
                        itemCount: newList.length);
                  },
                ),
              )
            ],
          )),
    );
  }

  _selectDate(BuildContext context) async {
    //first date while we click custom
    final initialDate = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -4)),
        end: DateTime.now());
    //picked date
    picked = (await showDateRangePicker(
      context: context,
      //if picked is null then will execute _initialDate
      initialDateRange: newRange ?? initialDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ));
    setState(() {
      if (picked == null) {
        return;
      } else {
        newRange = picked!;
        // startDate = newRange!.start;
        // endDate = newRange!.end;
      }
      TransactionDB.instance.sortedCustom(startDate!, endDate!);
      picked == null;
    });
  }
}

sortedMonth(String other) async {
  TransactionDB.instance.incomeFilterlist.value.clear();
  TransactionDB.instance.expenseFilterlist.value.clear();
  TransactionDB.instance.filterListNotifier.value.clear();
  for (TransactionModel i
      in TransactionDB.instance.transactionListNotifier.value) {
    if (i.date.month.toString() == other && i.type == CategoryType.income) {
      TransactionDB.instance.incomeFilterlist.value.add(i);
      TransactionDB.instance.filterListNotifier.value.add(i);
    } else if (i.date.month.toString() == other &&
        i.type == CategoryType.expense) {
      TransactionDB.instance.expenseFilterlist.value.add(i);
      TransactionDB.instance.filterListNotifier.value.add(i);
    }
  }
}

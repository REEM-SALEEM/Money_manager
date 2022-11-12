import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';
import '../widgets/edit_transactions.dart';

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
                      //Initially 'All'
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
                            return Slidable(
                              direction: Axis.horizontal,
                              key: Key(value.id!),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      TransactionDB.instance
                                          .deleteTransaction(value.id!);
                                      showTopSnackBar(
                                          context,
                                          const CustomSnackBar.error(
                                              message:
                                                  "Data Deleted Successfully"),
                                          displayDuration:
                                              const Duration(seconds: 2));
                                    },
                                    backgroundColor:
                                        const Color.fromARGB(255, 216, 59, 47),
                                    icon: Icons.delete,
                                    label: 'delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ScreenEdits(
                                                    transactionModel: value,
                                                    index: index,
                                                  )));
                                    },
                                    backgroundColor:
                                        // Color.fromARGB(255, 38, 113, 40),
                                        const Color.fromARGB(255, 45, 117, 176),
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  )
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 78, 52),
                                            Color.fromARGB(255, 3, 92, 62),
                                            Colors.green,
                                            Color.fromARGB(255, 134, 255, 82)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0, 0.2, 0.5, 0.8]),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        parseDate(value.date),
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    ' ₹ ${value.amount.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.green),
                                  ),
                                  title: Text(
                                    value.category.name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            );
                          } else if (dp == 'Expense' &&
                              value.type == CategoryType.expense) {
                            return Slidable(
                              direction: Axis.horizontal,
                              key: Key(value.id!),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      TransactionDB.instance
                                          .deleteTransaction(value.id!);
                                      showTopSnackBar(
                                          context,
                                          const CustomSnackBar.error(
                                              message:
                                                  "Data Deleted Successfully"),
                                          displayDuration:
                                              const Duration(seconds: 2));
                                    },
                                    backgroundColor:
                                        const Color.fromARGB(255, 216, 59, 47),
                                    icon: Icons.delete,
                                    label: 'delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ScreenEdits(
                                                    transactionModel: value,
                                                    index: index,
                                                  )));
                                    },
                                    backgroundColor:
                                        // Color.fromARGB(255, 38, 113, 40),
                                        const Color.fromARGB(255, 45, 117, 176),
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  )
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: const LinearGradient(
                                          colors: [
                                            Colors.orange,
                                            Colors.orangeAccent,
                                            Colors.red,
                                            Colors.redAccent
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0, 0.2, 0.5, 0.8]),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        parseDate(value.date),
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    ' ₹ ${value.amount.toString()}',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.red),
                                  ),
                                  title: Text(
                                    value.category.name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
                            );
                          } else if (dp == 'Overall') {
                            return Slidable(
                              direction: Axis.horizontal,
                              key: Key(value.id!),
                              startActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      TransactionDB.instance
                                          .deleteTransaction(value.id!);
                                      showTopSnackBar(
                                          context,
                                          const CustomSnackBar.error(
                                              message:
                                                  "Data Deleted Successfully"),
                                          displayDuration:
                                              const Duration(seconds: 2));
                                    },
                                    backgroundColor:
                                        const Color.fromARGB(255, 216, 59, 47),
                                    icon: Icons.delete,
                                    label: 'delete',
                                  ),
                                  SlidableAction(
                                    onPressed: (ctx) {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => ScreenEdits(
                                                    transactionModel: value,
                                                    index: index,
                                                  )));
                                    },
                                    backgroundColor:
                                        // Color.fromARGB(255, 38, 113, 40),
                                        const Color.fromARGB(255, 45, 117, 176),
                                    icon: Icons.edit,
                                    label: 'Edit',
                                  )
                                ],
                              ),
                              child: Card(
                                elevation: 0,
                                child: ListTile(
                                  leading: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      gradient: value.type ==
                                              CategoryType.income
                                          ? const LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 0, 78, 52),
                                                Color.fromARGB(255, 3, 92, 62),
                                                Colors.green,
                                                Color.fromARGB(
                                                    255, 134, 255, 82)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [0, 0.2, 0.5, 0.8])
                                          : const LinearGradient(
                                              colors: [
                                                Colors.orange,
                                                Colors.orangeAccent,
                                                Colors.red,
                                                Colors.redAccent
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              stops: [0, 0.2, 0.5, 0.8]),
                                      boxShadow: const [
                                        BoxShadow(
                                          spreadRadius: 4,
                                          blurRadius: 10,
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        parseDate(value.date),
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 48, 48, 48),
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ),
                                  subtitle: Text(
                                    ' ₹ ${value.amount.toString()}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: value.type == CategoryType.income
                                            ? Colors.green
                                            : Colors.red),
                                  ),
                                  title: Text(
                                    value.category.name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900),
                                  ),
                                ),
                              ),
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

  //*Date Format
  String parseDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '  ${splittedDate.last}\n ${splittedDate.first}';
  }
}

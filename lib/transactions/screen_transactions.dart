import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:intl/intl.dart';
import 'package:money_manager/refactors/transactions.dart';
import 'package:money_manager/transactions/view/transactions_view.dart';
import 'package:money_manager/transactions/widgets/edit_transactions.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../model/transaction/transaction_model.dart';
import 'widgets/add_transactions.dart';

class ScreenTransactions extends StatefulWidget {
  const ScreenTransactions({
    super.key,
  });

  @override
  State<ScreenTransactions> createState() => _ScreenTransactionsState();
}

class _ScreenTransactionsState extends State<ScreenTransactions> {
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const AddTransactions()),
                ),
              );
            },
            backgroundColor: Colors.black,
            foregroundColor: const Color.fromARGB(255, 184, 252, 121),
            child: const Icon(Icons.add, size: 30)),
        body: Column(children: [
          const TransactionsRef(
              textFirst1: 'TOTAL BALANCE',
              textFirst2: '₹ ',
              textSec1: 'INCOME',
              textSec2: '₹ ',
              textThird1: 'EXPENSE',
              textThird2: '- ₹ '),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(children: [
              const Text('RECENT TRANSACTIONS:',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(width: 140),
              Container(
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TransactionList(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      // Text('View All', style: TextStyle(color: Colors.white)),
                      Icon(Icons.arrow_right_alt, color: Colors.white)
                    ],
                  ),
                ),
              ),
            ]),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: TransactionDB.instance.transactionListNotifier,
              builder: (BuildContext ctx, List<TransactionModel> newList,
                  Widget? _) {
                return ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final value = newList[index];
                      return Slidable(
                        direction: Axis.horizontal,
                        key: Key(value.id!),
                        startActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (ctx) {
                                setState(() {
                                  TransactionDB.instance
                                      .deleteTransaction(value.id!);
                                       showTopSnackBar(context,
                          const CustomSnackBar.error(message: "Data Deleted Successfully"),
                          displayDuration: const Duration(seconds: 2));
                                });
                              },
                              backgroundColor:
                                  const Color.fromARGB(255, 216, 59, 47),
                              icon: Icons.delete,
                              label: 'delete',
                            ),
                            SlidableAction(
                              onPressed: (ctx) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ScreenEdits(
                                        transactionModel: value,
                                        index: index)));
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
                                gradient: value.type == CategoryType.expense
                                    ? const LinearGradient(
                                        colors: [
                                          Colors.orange,
                                          Colors.orangeAccent,
                                          Colors.red,
                                          Colors.redAccent
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        stops: [0, 0.2, 0.5, 0.8])
                                    : const LinearGradient(
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
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    parseDate(value.date),
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 48, 48, 48),
                                        fontWeight: FontWeight.w900),
                                  ),
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
                                  fontSize: 16, fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: newList.length < 5 ? newList.length : 5);
              },
            ),
          ),
        ]),
      ),
    );
  }

//*Date Format
  String parseDate(DateTime date) {
    final formattedDate = DateFormat.MMMd().format(date);
    final splittedDate = formattedDate.split(' ');
    return '  ${splittedDate.last}\n ${splittedDate.first}';
  }

//*Amount Calculation
  currentbalance(List<TransactionModel> value) async {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
//value = list of transaction model & i = iterator for in()
    for (TransactionModel i in value) {
      if (i.category.type == CategoryType.income) {
        totalIncome = totalIncome + i.amount;
      }
      if (i.category.type == CategoryType.expense) {
        totalExpense = totalExpense + i.amount;
      }
    }
    totalBalance = totalIncome - totalExpense;
    if (totalBalance < 0) {
      totalBalance = 0;
    }
  }
}

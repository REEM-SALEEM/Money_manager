import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/refactors/transactions.dart';
import 'package:money_manager/transactions/refactor/card_refactor.dart';
import 'package:money_manager/transactions/view/transactions_view.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/model/category/category_model.dart';
import '../model/transaction/transaction_model.dart';
import 'widgets/add_transactions.dart';
import 'package:sizer/sizer.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                const Text('RECENT TRANSACTIONS:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(width: 28.w),
                Container(
                  height: 5.h,
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
                        Icon(Icons.arrow_right_alt, color: Colors.white),
                      ],
                    ),
                  ),
                ),
               
              ]),
            ),
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
                      return CardRefactor(
                        date: value.date,
                        amount: value.amount,
                        catname: value.category.name,
                        id: value.id,
                        valueedit: value,
                        indexedit: index,
                        type: value.type,
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

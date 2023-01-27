import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/Controller/provider/prov_categoryfunctions.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:money_manager/View/transactions/refactor/card_refactor.dart';
import 'package:money_manager/View/transactions/view/transactions_view.dart';
import 'package:money_manager/refactors/transactions.dart';
import 'package:provider/provider.dart';
import 'widgets/add_transactions.dart';
import 'package:sizer/sizer.dart';

class ScreenTransactions extends StatelessWidget {
  const ScreenTransactions({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvTransactionDB>(context, listen: false)
          .transactionListNotifier;
    });
    Provider.of<ProvTransactionDB>(context, listen: false).refresh();
    Provider.of<ProvCategoryDB>(context, listen: false).refreshUI();
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) => AddTransactions()),
              ));
              Provider.of<ProvTCalender>(context, listen: false).selectedDate =
                  null;
            },
            backgroundColor: Colors.black,
            foregroundColor: const Color.fromARGB(255, 184, 252, 121),
            child: const Icon(Icons.add, size: 30)),
        body: Column(children: [
          TransactionsRef(
              textFirst1: 'TOTAL BALANCE',
              textFirst2: '₹ ',
              textSec1: 'INCOME',
              textSec2: '₹ ',
              textThird1: 'EXPENSE',
              textThird2: '₹ '),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
            child: Center(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('RECENT TRANSACTIONS',
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
                        onPressed: () async {
                          Provider.of<ProvTCalender>(context, listen: false)
                              .selectedDate = null;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TransactionList(),
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
            child: Consumer<ProvTransactionDB>(
              builder:
                  (BuildContext ctx, ProvTransactionDB newList, Widget? _) {
                return newList.transactionListNotifier.isEmpty
                    ? const Center(
                        child: Text(
                          'No data found',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final value = newList.transactionListNotifier[index];
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
                        itemCount: newList.transactionListNotifier.length < 5
                            ? newList.transactionListNotifier.length
                            : 5);
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
}

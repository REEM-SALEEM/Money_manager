import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/category/category_model.dart';
import '../model/transaction/transaction_model.dart';

class TransactionsRef extends StatefulWidget {
  final String textFirst1;
  final String textFirst2;
  final String textSec1;
  final String textSec2;
  final String textThird1;
  final String textThird2;
  const TransactionsRef({
    super.key,
    required this.textFirst1,
    required this.textFirst2,
    required this.textSec1,
    required this.textSec2,
    required this.textThird1,
    required this.textThird2,
  });

  @override
  State<TransactionsRef> createState() => _TransactionsRefState();
}

class _TransactionsRefState extends State<TransactionsRef> {
  //declare sharedpreference value.
  String? savedName;
  //declare & initialize(initially 0) Amount value.
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  @override
  Widget build(BuildContext context) {
    getSavedData(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      child: Column(children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            savedName == null //checking savedname is null/not here!
                ? const Text('is null')
                : Text(
                    'Hi, ${savedName!.toUpperCase()}!',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 19),
                  ),
            const SizedBox(height: 5),
            Text(
              DateFormat.yMMMMd().format(DateTime.now()),
              style: const TextStyle(
                color: Color.fromARGB(255, 166, 165, 165),
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
            ),
          ]),
        ]),
        const SizedBox(height: 23),
        ValueListenableBuilder(
          valueListenable: TransactionDB.instance.transactionListNotifier,
          builder:
              (BuildContext ctx, List<TransactionModel> modelList, Widget? _) {
            currentbalance(modelList);
            return Stack(children: [
              //#main
              SizedBox(
                width: 410,
                height: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            Colors.black,
                            Color.fromARGB(255, 24, 23, 23),
                            Color.fromARGB(255, 33, 32, 32),
                            Color.fromARGB(255, 57, 57, 57),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 0.2, 0.5, 0.8]),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                      child: Column(children: [
                        Text(widget.textFirst1,
                            style: const TextStyle(
                                // fontFamily: "Teko",
                                letterSpacing: 4,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 5),
                        Text('${widget.textFirst2}$totalBalance',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 35)),
                      ]),
                    ),
                  ),
                ),
              ),
              //#1
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 150, 0, 0),
                child: SizedBox(
                  width: 170,
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 78, 52),
                              Color.fromARGB(255, 3, 92, 62),
                              Colors.green,
                              Color.fromARGB(255, 134, 255, 82)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0, 0.2, 0.5, 0.8]),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              Text(widget.textSec1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17)),
                              const SizedBox(height: 2),
                              Text('${widget.textSec2} $totalIncome',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24))
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
              //#2
              Padding(
                padding: const EdgeInsets.fromLTRB(185, 150, 0, 0),
                child: SizedBox(
                  width: 170,
                  height: 80,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange,
                            Colors.orangeAccent,
                            Colors.red,
                            Colors.redAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0, 0.2, 0.5, 0.8],
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 6),
                              Text(widget.textThird1,
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 2),
                              Text('${widget.textThird2}$totalExpense',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold))
                            ]),
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ),
      ]),
    );
  }

//*get the saved name
  Future<void> getSavedData(BuildContext context) async {
    final sharedprefs = await SharedPreferences.getInstance();
    //getter method - get the saved name by key
    savedName = sharedprefs.getString('saved_name');
    setState(() {});
  }

//*Amount calculation
  currentbalance(List<TransactionModel> value) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;

    for (TransactionModel value in value) {
      if (value.category.type == CategoryType.income) {
        totalIncome = totalIncome + value.amount;
      }
      if (value.category.type == CategoryType.expense) {
        totalExpense = totalExpense + value.amount;
      }
    }
    totalBalance = totalIncome - totalExpense;
    if (totalBalance < 0) {
      totalBalance = 0;
    }
  }
}

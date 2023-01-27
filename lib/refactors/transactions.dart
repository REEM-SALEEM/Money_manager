import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import '../Controller/provider/prov_sharedpreference.dart';
import '../Controller/provider/prov_tot.dart';

class TransactionsRef extends StatelessWidget {
  final String textFirst1;
  final String textFirst2;
  final String textSec1;
  final String textSec2;
  final String textThird1;
  final String textThird2;
  TransactionsRef({
    super.key,
    required this.textFirst1,
    required this.textFirst2,
    required this.textSec1,
    required this.textSec2,
    required this.textThird1,
    required this.textThird2,
  });

  dynamic paps;
  dynamic insp;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var insp = Provider.of<ProvTransactionDB>(context, listen: false)
          .transactionListNotifier;
      paps = context.read<Total>().currentbalance(insp);

      Provider.of<ProvGetnSet>(context, listen: false).getSavedData(context);
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
      child: Column(children: [
        Row(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Consumer<ProvGetnSet>(
              builder: (BuildContext context, value, Widget? child) {
                return value.savedName ==
                        null //checking savedname is null/not here!
                    ? const Text('is null')
                    : Text(
                        'Hi, ${value.savedName!.toUpperCase()}!',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19),
                      );
              },
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
        Consumer<Total>(
          builder: (BuildContext ctx, modelList, Widget? _) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              var insp = Provider.of<ProvTransactionDB>(context, listen: false)
                  .transactionListNotifier;
              context.read<Total>().currentbalance(insp);
            });

            return Stack(children: [
              //#main
              SizedBox(
                width: 90.w,
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
                        Text(textFirst1,
                            style: const TextStyle(
                                // fontFamily: "Teko",
                                letterSpacing: 4,
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 15)),
                        const SizedBox(height: 5),
                        Text('$textFirst2${modelList.totalBalance}',
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
              Row(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 150, 0, 0),
                  child: SizedBox(
                    width: 42.w,
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
                                Text(textSec1,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 17)),
                                const SizedBox(height: 2),
                                Text('$textSec2 ${modelList.totalIncome}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24))
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1.w,
                ),
                //#2
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 150, 0, 0),
                  child: SizedBox(
                    width: 42.w,
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
                                Text(textThird1,
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 2),
                                Text('$textThird2${modelList.totalExpense}',
                                    style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ]);
          },
        ),
      ]),
    );
  }
}

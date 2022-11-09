import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../db/transaction/transaction_db.dart';
import '../model/category/category_model.dart';
import '../model/transaction/transaction_model.dart';
import '../transactions/widgets/edit_transactions.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: TransactionDB.instance.transactionListNotifier,
        builder: (BuildContext ctx, List<TransactionModel> newList, Widget? _) {
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
                          TransactionDB.instance.deleteTransaction(value.id!);
                        },
                        backgroundColor: const Color.fromARGB(255, 216, 59, 47),
                        icon: Icons.delete,
                        label: 'delete',
                      ),
                      SlidableAction(
                        onPressed: (ctx) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScreenEdits(
                                transactionModel: value,
                                index: index,
                              ),
                            ),
                          );
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
                          child: Text(
                            parseDate(value.date),
                            style: const TextStyle(
                                color: Color.fromARGB(255, 48, 48, 48),
                                fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      subtitle: Text(
                        ' ₹ ${value.amount.toString()}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, color: Colors.green),
                      ),
                      title: Text(
                        value.category.name.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                );
              },
              itemCount: newList.length);
        },
      ),
    );
  }

  String parseDate(DateTime date) {
    final datee = DateFormat.MMMd().format(date);
    final splittedDate = datee.split(' ');
    return '${splittedDate.last}\n${splittedDate.first}';
  }
}

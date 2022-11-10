import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../transactions/widgets/edit_transactions.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';

class IncomeList extends StatefulWidget {
  const IncomeList({super.key});

  @override
  State<IncomeList> createState() => _IncomeListState();
}

String dropdownValue = 'All';
List<String> items = ['All', 'Today', 'Yesterday', 'Month', 'Custom'];

class _IncomeListState extends State<IncomeList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: const Text('INCOME',
              style: TextStyle(color: Colors.white, fontSize: 17)),
          backgroundColor: Colors.black,
          elevation: 0,
        ),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 8, 6),
                child: Container(
                  height: 32,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.lightGreen),
                  //----Dropdown Button
                  child: DropdownButton<String>(
                    //Initially 'All'
                    value: dropdownValue,
                    onChanged: (String? value) async {
                      setState(
                        () {
                          dropdownValue = value!;
                          TransactionDB.instance.filterList(dropdownValue);
                        },
                      );
                    },
                    items: items.map<DropdownMenuItem<String>>((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                  ),
                ),
              )
            ]),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: dropdownValue == 'All'
                    ? TransactionDB.instance.incometransactionListNotifier
                    : TransactionDB.instance.incomeFilterlist,
                builder: (BuildContext ctx, List<TransactionModel> newList,
                    Widget? _) {
                  return ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final value = newList[index];
                        if (value.type == CategoryType.income) {
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
                                  },
                                  backgroundColor:
                                      const Color.fromARGB(255, 216, 59, 47),
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
                        }
                        return Column();
                      },
                      itemCount: newList.length);
                },
              ),
            )
          ],
        ),
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

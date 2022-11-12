import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../db/transaction/transaction_db.dart';
import '../../model/category/category_model.dart';
import '../widgets/edit_transactions.dart';

class CardRefactor extends StatefulWidget {
  final dynamic date;
  final dynamic amount;
  final dynamic catname;
  final dynamic id;
  final dynamic valueedit;
  final dynamic indexedit;
  final dynamic type;

  const CardRefactor({
    super.key,
    required this.date,
    required this.amount,
    required this.catname,
    required this.id,
    required this.valueedit,
    required this.indexedit,
    required this.type,
  });

  @override
  State<CardRefactor> createState() => _CardRefactorState();
}

class _CardRefactorState extends State<CardRefactor> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      key: Key(widget.id!),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {
              TransactionDB.instance.deleteTransaction(widget.id!);
              showTopSnackBar(
                  context,
                  const CustomSnackBar.error(
                      message: "Data Deleted Successfully"),
                  displayDuration: const Duration(seconds: 2));
            },
            backgroundColor: const Color.fromARGB(255, 216, 59, 47),
            icon: Icons.delete,
            label: 'delete',
          ),
          SlidableAction(
            onPressed: (ctx) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ScreenEdits(
                        transactionModel: widget.valueedit,
                        index: widget.indexedit,
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
              gradient: widget.type == CategoryType.expense
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
                parseDate(widget.date),
                style: const TextStyle(
                    color: Color.fromARGB(255, 48, 48, 48),
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
          subtitle: Text(
            ' ₹ ${widget.amount.toString()}',
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w900, color: Colors.green),
          ),
          title: Text(
            widget.catname.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
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

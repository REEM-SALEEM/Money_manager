import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manager/Controller/provider/prov_dateparsing.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Model/model/category/category_model.dart';
import '../widgets/edit_transactions.dart';

class CardRefactor extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      key: Key(id!),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) {
              Provider.of<ProvTransactionDB>(context, listen: false)
                  .deleteTransaction(id!);
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
                        transactionModel: valueedit,
                        index: indexedit,
                      )));
            },
            backgroundColor: const Color.fromARGB(255, 45, 117, 176),
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
              gradient: type == CategoryType.expense
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
              child: Consumer<ProvParse>(
                builder: (BuildContext context, value, Widget? child) {
                  return Text(
                    value.parseDate(date),
                    // Provider.of<ProvParse>(context, listen: false).parseDate(date),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 48, 48, 48),
                        fontWeight: FontWeight.w900),
                  );
                },
              ),
            ),
          ),
          subtitle: Text(
            ' ₹ ${amount.toString()}',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: type == CategoryType.income ? Colors.green : Colors.red),
          ),
          title: Text(
            catname.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
      ),
    );
  }
}

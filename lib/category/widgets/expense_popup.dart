import 'package:flutter/material.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../db/category/category_db.dart';

Future<void> showExpensepopup(BuildContext context) async {
  final TextEditingController expenseController = TextEditingController();
  showDialog(
    context: context,
    builder: ((ctx) {
      return SimpleDialog(
        title: const Text('ADD EXPENSE'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: expenseController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'expense',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                final name = expenseController.text;
                if (name.isEmpty) {
                  return;
                }
                final expensecategory = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    type: CategoryType.expense,
                    name: name);
                CategoryDB.instance.insertCategory(expensecategory);

                Navigator.of(ctx).pop();
                showTopSnackBar(context,
                    const CustomSnackBar.success(message: "Data Entered"),
                    displayDuration: const Duration(seconds: 2));
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      );
    }),
  );
}

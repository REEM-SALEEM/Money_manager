import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/category/category_db.dart';
import '../../model/category/category_model.dart';

Future<void> showIncomepopup(BuildContext context) async {
  final TextEditingController incomeController = TextEditingController();

  showDialog(
    context: context,
    builder: ((ctx) {
      return SimpleDialog(
        title: const Text('ADD INCOME'),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: incomeController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'income',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                final name1 = incomeController.text;
                if (name1.isEmpty) {
                  return;
                }
                final incomecategory = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    type: CategoryType.income,
                    name: name1);
                CategoryDB.instance.insertCategory(incomecategory);

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

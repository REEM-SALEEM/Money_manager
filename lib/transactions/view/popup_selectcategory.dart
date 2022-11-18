import 'package:flutter/material.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../db/category/category_db.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
Future<void> selectCategoryPopup(BuildContext context) async {
  final TextEditingController categoryController = TextEditingController();
  showDialog(
    context: context,
    builder: ((ctx) {
      return SimpleDialog(
        title: const Text('ADD CATEGORY'),
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: const [
            RadioButton(title: 'INCOME', type: CategoryType.income),
            RadioButton(title: 'EXPENSE', type: CategoryType.expense),
          ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'add category...',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () {
                final controller = categoryController.text;
                if (controller.isEmpty) {
                  return;
                }
                final type = selectedCategoryNotifier.value;
                final overallcategory = CategoryModel(
                    id: DateTime.now().microsecondsSinceEpoch.toString(),
                    type: type,
                    name: controller);

                CategoryDB.instance.insertCategory(overallcategory);
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

class RadioButton extends StatefulWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  State<RadioButton> createState() => _RadioButtonState();
}

class _RadioButtonState extends State<RadioButton> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 10, height: 30),
      ValueListenableBuilder(
        valueListenable: selectedCategoryNotifier,
        builder: (BuildContext ctx, CategoryType newcategory, Widget? _) {
          return Radio<CategoryType>(
              value: widget.type,
              groupValue: newcategory,
              onChanged: (value) {
                selectedCategoryNotifier.value = value!;
                selectedCategoryNotifier.notifyListeners();
                setState(() {});
              });
        },
      ),
      Text(widget.title),
    ]);
  }
}

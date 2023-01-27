import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Model/model/category/category_model.dart';
const categorydbname = 'category_database';
class ProvCategoryDB extends ChangeNotifier {
  ProvCategoryDB._internal();
  static ProvCategoryDB instance = ProvCategoryDB._internal();
  factory ProvCategoryDB() {
    return instance;
  }
  List<CategoryModel> categoryList = [];
  List<CategoryModel> incomeCategoryList = [];
  List<CategoryModel> expenseCategoryList = [];

  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    await categoryDB.put(value.id, value);
    refreshUI();
    notifyListeners();
  }

  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    notifyListeners();
    return categoryDB.values.toList();
  }

  Future<void> refreshUI() async {
    final allcategories = await getCategories();
    incomeCategoryList.clear();
    expenseCategoryList.clear();
    await Future.forEach(
      allcategories,
      (CategoryModel category) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.add(category);
        } else {
          expenseCategoryList.add(category);
        }
        notifyListeners();
      },
    );
    notifyListeners();
  }

  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    categoryDB.delete(categoryID);
    refreshUI();
    notifyListeners();
  }

  Future<dynamic> categoryClear() async {
    final categoryDB = await Hive.openBox<CategoryModel>(categorydbname);
    categoryDB.clear();
    notifyListeners();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
class ProvFloating extends ChangeNotifier{
  int selectedindexTab = 0;
  get indexTab => selectedindexTab;
  set indexTab(index) {
    selectedindexTab = index;
    notifyListeners();
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////
class ProvPopup extends ChangeNotifier {
  final _formKey = GlobalKey<FormState>();

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
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: expenseController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'expense',
                  ),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'This is required';
                    }
                    return null;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  final name = expenseController.text;

                  if (_formKey.currentState!.validate() == true) {
                    final expensecategory = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        type: CategoryType.expense,
                        name: name);
                    
                    Provider.of<ProvCategoryDB>(context, listen: false)
                        .insertCategory(expensecategory);

                    Navigator.of(ctx).pop();
                    showTopSnackBar(context,
                        const CustomSnackBar.success(message: "Data Entered"),
                        displayDuration: const Duration(seconds: 2));
                  }
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
    notifyListeners();
  }

  Future<void> showIncomepopup(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController incomeController = TextEditingController();

    showDialog(
      context: context,
      builder: ((ctx) {
        return SimpleDialog(
          title: const Text('ADD INCOME'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: incomeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'income',
                  ),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return 'This is required';
                    }
                    return null;
                  }),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () {
                  final name1 = incomeController.text;
                  if (_formKey.currentState!.validate() == true) {
                    final incomecategory = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        type: CategoryType.income,
                        name: name1);
                    // CategoryDB.instance.insertCategory(incomecategory);
                    Provider.of<ProvCategoryDB>(context, listen: false)
                        .insertCategory(incomecategory);

                    Navigator.of(ctx).pop();
                    showTopSnackBar(context,
                        const CustomSnackBar.success(message: "Data Entered"),
                        displayDuration: const Duration(seconds: 2));
                  }
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
    notifyListeners();
  }
}

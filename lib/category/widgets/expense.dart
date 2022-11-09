import 'package:flutter/material.dart';
import '../../db/category/category_db.dart';
import '../../model/category/category_model.dart';
import 'expense_popup.dart';

class Expense extends StatefulWidget {
  const Expense({super.key});

  @override
  State<Expense> createState() => _ExpenseState();
}

class _ExpenseState extends State<Expense> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
              valueListenable: CategoryDB().expenseCategoryList,
              builder:
                  (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 6 / 1.7,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: newList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final category = newList[index];
                      return Container(
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
                                stops: [0, 0.2, 0.5, 0.8]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: ListTile(
                          title: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              CategoryDB.instance.deleteCategory(category.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      );
                    });
              }),
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showExpensepopup(context);
            },
            backgroundColor: Colors.black,
            foregroundColor: Colors.orangeAccent,
            child: const Icon(Icons.add, size: 30)));
  }
}

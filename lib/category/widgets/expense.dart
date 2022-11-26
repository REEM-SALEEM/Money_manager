import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/category/category_db.dart';
import '../../model/category/category_model.dart';

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
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ListTile(
                        title: Text(
                          category.name,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            deletePopup(category.id);
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
    );
  }

  deletePopup(String id) async {
    showDialog(
      context: context,
      builder: ((context) {
        return SimpleDialog(backgroundColor: Colors.black, children: [
          const Center(
            child: Text(
              'Are you sure to delete?',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: 80,
                child: ElevatedButton(
                    onPressed: () {
                      CategoryDB.instance.deleteCategory(id);
                      Navigator.of(context).pop(context);
                      showTopSnackBar(context,
                          const CustomSnackBar.error(message: "Deleted"),
                          displayDuration: const Duration(seconds: 2));
                    },
                    child: const Text('Yes')),
              ),
              SizedBox(
                width: 80,
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        Navigator.of(context).pop(context);
                      });
                    },
                    child: const Text('Cancel')),
              ),
            ],
          )
        ]);
      }),
    );
  }
}

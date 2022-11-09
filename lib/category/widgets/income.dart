import 'package:flutter/material.dart';
import 'package:money_manager/category/widgets/income_popup.dart';
import '../../db/category/category_db.dart';
import '../../model/category/category_model.dart';

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 17, 17, 17),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder(
              valueListenable: CategoryDB().incomeCategoryList,
              builder:
                  (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
                return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 6 / 1.8,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                    itemCount: newList.length,
                    itemBuilder: (BuildContext ctx, index) {
                      final category = newList[index];
                      return Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 78, 52),
                                  Color.fromARGB(255, 3, 92, 62),
                                  Colors.green,
                                  Color.fromARGB(255, 134, 255, 82)
                                  //add more colors for gradient
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
              showIncomepopup(context);
            },
            backgroundColor: Colors.black,
            foregroundColor: const Color.fromARGB(255, 184, 252, 121),
            child: const Icon(Icons.add, size: 30)));
  }
}

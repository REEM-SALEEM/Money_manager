import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../Controller/provider/prov_categoryfunctions.dart';

class Expense extends StatelessWidget {
  const Expense({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvCategoryDB>(context, listen: false).expenseCategoryList;
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 17, 17, 17),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Consumer<ProvCategoryDB>(
            builder: (BuildContext ctx, ProvCategoryDB hi, Widget? _) {
          return GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 6 / 1.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemCount: hi.expenseCategoryList.length,
              itemBuilder: (BuildContext ctx, index) {
                final category = hi.expenseCategoryList[index];
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
                      category.name  ,
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    trailing: IconButton(
                      padding: const EdgeInsets.fromLTRB(30, 0, 0, 4),
                      onPressed: () {
                        deletePopup(category.id, context);
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

  deletePopup(String id, BuildContext context) async {
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
                      Provider.of<ProvCategoryDB>(context, listen: false)
                          .deleteCategory(id);

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
                      Navigator.of(context).pop(context);
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

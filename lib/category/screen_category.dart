import 'package:flutter/material.dart';
import 'package:money_manager/category/widgets/expense.dart';
import 'package:money_manager/category/widgets/income.dart';
import 'package:sizer/sizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../db/category/category_db.dart';
import '../model/category/category_model.dart';

class ScreenCategory extends StatefulWidget {
  const ScreenCategory({super.key});

  @override
  State<ScreenCategory> createState() => _ScreenCategoryState();
}

final _formKey = GlobalKey<FormState>();
int indexTab = 0;

class _ScreenCategoryState extends State<ScreenCategory> {
  @override
  void initState() {
    setState(() {});
    CategoryDB().refreshUI();
    setState(() {
      FloatingActionButton;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //To control the tabs (no. of tabs == length)
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            centerTitle: true,
            title: const Text("Categories",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            backgroundColor: Colors.black),
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0),
                topLeft: Radius.circular(30.0)),
            color: Color.fromARGB(255, 17, 17, 17),
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 40, 8, 0),
                child: Container(
                  height: 55,
                  width: 350,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 87, 84, 84),
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(11)),
                  //----Tab bar
                  child: TabBar(
                      onTap: (index) {
                        setState(() {
                          indexTab = index;
                        });
                      },
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      tabs: const [
                        Tab(
                          text: 'Income',
                        ),
                        Tab(text: 'Expense')
                      ]),
                ),
              ),
              const SizedBox(
                  width: 400,
                  height: 507,
                  child: TabBarView(children: [Income(), Expense()]))
            ]),
          ),
        ),
        floatingActionButton: indexTab == 0
            ? FloatingActionButton(
                onPressed: () {
                  showIncomepopup(context);
                },
                backgroundColor: Colors.black,
                foregroundColor: const Color.fromARGB(255, 184, 252, 121),
                child: const Icon(Icons.add, size: 30),
              )
            : FloatingActionButton(
                onPressed: () {
                  showExpensepopup(context);
                },
                backgroundColor: Colors.black,
                foregroundColor: Colors.orangeAccent,
                child: const Icon(Icons.add, size: 30)),
      ),
    );
  }

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
                    CategoryDB.instance.insertCategory(expensecategory);

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
  }

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
                    CategoryDB.instance.insertCategory(incomecategory);

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
  }
}

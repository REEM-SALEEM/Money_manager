import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_addbutton.dart';
import 'package:money_manager/Controller/provider/prov_tot.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../../Controller/provider/prov_categoryfunctions.dart';
import '../../../Controller/provider/prov_transactions.dart';
import '../../../Model/model/category/category_model.dart';
import '../../../Model/model/transaction/transaction_model.dart';

class AddTransactions extends StatelessWidget {
  AddTransactions({super.key});

  //declaring value to store selected date
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? selectedCategoryModel;
  String? _categoryID;

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   TransactionDB.instance.refresh();
  //   print('hfdgjhfd');
  //     _selectedCategorytype = CategoryType.income;
  //   // Provider.of<ProvCategoryDB>(context, listen: false).refreshUI();
  //   // _selectedCategorytype = CategoryType.income;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    //       final Total totatl=Total();
    // totatl.currentbalance(value);
    // _selectedCategorytype = CategoryType.income;
    _selectedCategorytype = CategoryType.income;

    Provider.of<ProvCategoryDB>(context, listen: false).refreshUI();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'TRANSACTIONS',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          height: 500,
          width: 365,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 227, 225, 225),
          ),
          child: Padding(
            padding: const EdgeInsets.all(9.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      const Text('DETAILS',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18)),
                      Consumer<ProvTRadio>(
                        builder: (BuildContext context, value, Widget? child) {
                          return Row(children: [
                            const SizedBox(width: 20, height: 30),
                            //#1 radio----
                            Radio(
                                value: CategoryType.income,
                                //groupvalue - value selected by user.
                                groupValue: _selectedCategorytype,
                                onChanged: (newValue) {
                                  _selectedCategorytype = CategoryType.income;
                                  value.selectedCategorytype =
                                      _selectedCategorytype;
                                  _categoryID = null;
                                }),
                            const Text(
                              'INCOME',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                            const SizedBox(width: 40),
                            //#2 radio----
                            Radio(
                                value: CategoryType.expense,
                                groupValue: _selectedCategorytype,
                                onChanged: (newValue) {
                                  _selectedCategorytype = CategoryType.expense;
                                  value.selectedCategorytype =
                                      _selectedCategorytype;
                                  _categoryID = null;
                                }),
                            const Text(
                              'EXPENSE',
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, fontSize: 18),
                            ),
                          ]);
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //----Calender
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green)),
                              child: Consumer<ProvTCalender>(
                                builder: (BuildContext context, value,
                                    Widget? child) {
                                  return TextButton.icon(
                                    onPressed: () async {
                                      final selectedDateTemp =
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate:
                                                  DateTime.now().subtract(
                                                const Duration(days: 365),
                                              ),
                                              lastDate: DateTime.now());
                                      //if Date is not selected
                                      if (selectedDateTemp == null) {
                                        // print(selectedDateTemp);
                                        return;
                                      } else {
                                        // print(selectedDateTemp);
                                        _selectedDate = selectedDateTemp;
                                        value.date = _selectedDate;
                                        // print(value.selectedDate!.day);
                                      }
                                    },
                                    icon: const Icon(Icons.date_range),
                                    label: Text(value.selectedDate == null
                                        ? 'Select Date'
                                        // "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
                                        : '${value.selectedDate!.day}/${value.selectedDate!.month}/${value.selectedDate!.year}'),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            //----Select category
                            Container(
                              width: 147,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                              ),
                              child: Consumer<ProvTCategory>(
                                builder: (BuildContext context, values,
                                    Widget? child) {
                                  return Center(
                                    child: Consumer<ProvTRadio>(
                                      builder: (BuildContext context,
                                          ProvTRadio value, Widget? child) {
                                        return DropdownButton<String>(
                                          underline: Column(),
                                          alignment:
                                              AlignmentDirectional.centerStart,
                                          hint: const Text('  SELECT CATEGORY',
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w900)),
                                          value: _categoryID,
                                          style: const TextStyle(
                                              color: Colors.green),
                                          items: (_selectedCategorytype ==
                                                      CategoryType.income
                                                  ? Provider.of<ProvCategoryDB>(
                                                          context,
                                                          listen: false)
                                                      .incomeCategoryList
                                                  : Provider.of<ProvCategoryDB>(
                                                          context,
                                                          listen: false)
                                                      .expenseCategoryList)
                                              /*value = list of category model
                                              .map = is used to create convert list to List of DropdownMenuItems*/
                                              .map((e) {
                                            /*converting each object from category model list to dropdownmenuitems and return */
                                            return DropdownMenuItem(
                                              value: e.id,
                                              child: Text("  ${e.name}"),
                                              onTap: () {
                                                selectedCategoryModel = e;
                                              },
                                            );
                                          }).toList(),
                                          onChanged: (selectedValue) {
                                            _categoryID = selectedValue;
                                            values.mon = _categoryID;
                                            // print(_categoryID);
                                          },
                                          icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.white),
                                          iconEnabledColor: Colors.black,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  selectCategoryPopup(context);
                                },
                                icon: const Icon(Icons.add))
                          ]),
                      const SizedBox(height: 20),
                      //----Amount
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _amount,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Amount',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Amount is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      //----Purpose
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _purpose,
                        maxLines: 5,
                        minLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Purpose',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Purpose is required.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      Center(
                        //----Add button
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(),
                          onPressed: (() {
                            if (_selectedDate == null) {
                              showTopSnackBar(
                                  context,
                                  const CustomSnackBar.error(
                                      icon: Icon(Icons.calendar_month,
                                          size: 150, color: Color(0x15000000)),
                                      message: "Select Date"),
                                  displayDuration: const Duration(seconds: 2));
                            } else if (selectedCategoryModel == null) {
                              showTopSnackBar(
                                  context,
                                  const CustomSnackBar.error(
                                      message: "SELECT CATEGORY"),
                                  displayDuration: const Duration(seconds: 2));
                            }
                            if (_formKey.currentState!.validate() == true) {
                              Provider.of<ProvAddButton>(context, listen: false)
                                  .addTransaction(
                                      context,
                                      _purpose,
                                      _amount,
                                      _selectedDate,
                                      selectedCategoryModel,
                                      _selectedCategorytype);
                            }
                          }),
                          child: const Text(
                            'ADD TRANSACTION',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> selectCategoryPopup(BuildContext context) async {
    final formKey = GlobalKey<FormState>();
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
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'add category...',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This is required.';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: () async {
                  final controller = categoryController.text;
                  if (formKey.currentState!.validate() == true) {
                    final type = selectedCategoryNotifier.value;
                    final overallcategory = CategoryModel(
                        id: DateTime.now().microsecondsSinceEpoch.toString(),
                        type: type,
                        name: controller);
                    await Provider.of<ProvCategoryDB>(context, listen: false)
                        .insertCategory(overallcategory);

                    Provider.of<ProvCategoryDB>(context, listen: false)
                        .expenseCategoryList;
                    Provider.of<ProvCategoryDB>(context, listen: false)
                        .incomeCategoryList;
                    Provider.of<ProvCategoryDB>(context, listen: false)
                        .refreshUI();

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

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
// CategoryType  newcategorytype = CategoryType.income;

class RadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  const RadioButton({super.key, required this.title, required this.type});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 10, height: 30),
      Consumer<ProvTCategorytype>(
        builder: (BuildContext ctx, val, Widget? _) {
          return Radio<CategoryType>(
              value: type,
              groupValue: val.sp,
              onChanged: (value) {
                selectedCategoryNotifier.value = value!;
                val.selectedCategorytype = selectedCategoryNotifier.value;
              });
        },
      ),
      Text(title),
    ]);
  }
}

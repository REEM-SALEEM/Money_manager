import 'package:flutter/material.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/category/category_db.dart';
import '../../db/transaction/transaction_db.dart';
import '../../model/transaction/transaction_model.dart';

class AddTransactions extends StatefulWidget {
  const AddTransactions({super.key});

  @override
  State<AddTransactions> createState() => _AddTransactionsState();
}
ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);
class _AddTransactionsState extends State<AddTransactions> {
  //declaring value to store selected date
  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? selectedCategoryModel;
  String? _categoryID;

  final TextEditingController _amount = TextEditingController();
  final TextEditingController _purpose = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    _selectedCategorytype = CategoryType.income;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                      Row(children: [
                        const SizedBox(width: 20, height: 30),
                        //#1 radio----
                        Radio(
                            value: CategoryType.income,
                            //groupvalue - value selected by user.
                            groupValue: _selectedCategorytype,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedCategorytype = CategoryType.income;
                                _categoryID = null;
                              });
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
                              setState(() {
                                _selectedCategorytype = CategoryType.expense;
                                _categoryID = null;
                              });
                            }),
                        const Text(
                          'EXPENSE',
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            //----Calender
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.green)),
                              child: TextButton.icon(
                                  onPressed: () async {
                                    final selectedDateTemp =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now().subtract(
                                              const Duration(days: 365),
                                            ),
                                            lastDate: DateTime.now());
                                    //if Date is not selected
                                    if (selectedDateTemp == null) {
                                      return;
                                    } else {
                                      setState(() {
                                        _selectedDate = selectedDateTemp;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.date_range),
                                  label: Text(_selectedDate == null
                                      ? 'Select Date'
                                      // "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}"
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}')),
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
                              child: Center(
                                child: DropdownButton<String>(
                                  underline: Column(),
                                  alignment: AlignmentDirectional.centerStart,
                                  hint: const Text('  SELECT CATEGORY',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900)),
                                  value: _categoryID,
                                  style: const TextStyle(color: Colors.green),
                                  items: (_selectedCategorytype ==
                                              CategoryType.income
                                          ? CategoryDB().incomeCategoryList
                                          : CategoryDB().expenseCategoryList)
                                      /*value = list of category model 
                                        .map = is used to create convert list to List of DropdownMenuItems*/
                                      .value
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
                                    setState(() {
                                      _categoryID = selectedValue;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  iconEnabledColor: Colors.black,
                                ),
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
                            setState(
                              () {
                                if (_selectedDate == null) {
                                  showTopSnackBar(
                                      context,
                                      const CustomSnackBar.error(
                                          icon: Icon(Icons.calendar_month,
                                              size: 150,
                                              color: Color(0x15000000)),
                                          message: "Select Date"),
                                      displayDuration:
                                          const Duration(seconds: 2));
                                } else if (selectedCategoryModel == null) {
                                  showTopSnackBar(
                                      context,
                                      const CustomSnackBar.error(
                                          message: "SELECT CATEGORY"),
                                      displayDuration:
                                          const Duration(seconds: 2));
                                }
                                if (_formKey.currentState!.validate() == true) {
                                  addTransaction();
                                }
                              },
                            );
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
                setState(() {
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
                CategoryDB.instance.expenseCategoryList.value;
                CategoryDB.instance.incomeCategoryList.value;
                CategoryDB.instance.refreshUI();
                Navigator.of(ctx).pop();
                showTopSnackBar(context,
                    const CustomSnackBar.success(message: "Data Entered"),
                    displayDuration: const Duration(seconds: 2));
                });
              
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
//*Add Transaction details.
  Future<void> addTransaction() async {
    final amountText = _amount.text;
    final purposeText = _purpose.text;

    if (amountText.isEmpty) {
      return;
    }

    if (purposeText.isEmpty) {
      return;
    }

    final parsedAmount = double.tryParse(amountText);
    if (parsedAmount == null) {
      return;
    }

    if (_selectedDate == null) {
      return;
    }

    if (selectedCategoryModel == null) {
      return;
    }

    final model = TransactionModel(
        amount: parsedAmount,
        purpose: purposeText,
        date: _selectedDate!,
        type: _selectedCategorytype!,
        category: selectedCategoryModel!,
        id: DateTime.now().toString());
    await TransactionDB.instance.addTransaction(model);

    setState(() {
      Navigator.of(context).pop();
    });
    TransactionDB.instance.refresh();
    if (mounted) {
      showTopSnackBar(
          context, const CustomSnackBar.success(message: "Data Entered"),
          displayDuration: const Duration(seconds: 2));
    }
  }
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
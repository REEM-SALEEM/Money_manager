import 'package:flutter/material.dart';
import 'package:money_manager/db/transaction/transaction_db.dart';
import 'package:money_manager/model/category/category_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../db/category/category_db.dart';
import '../../model/transaction/transaction_model.dart';

class ScreenEdits extends StatefulWidget {
  final TransactionModel transactionModel;
  final int index;

  const ScreenEdits({super.key, required this.transactionModel, required this.index});

  @override
  State<ScreenEdits> createState() => _ScreenEditsState();
}

class _ScreenEditsState extends State<ScreenEdits> {
  final _amountEditing = TextEditingController();
  final _purposeEditing = TextEditingController();

  DateTime? _selectedDate;
  CategoryType? _selectedCategorytype;
  CategoryModel? _categoryModel;
   String? categoryID;
   int? index;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    TransactionDB.instance.refresh();
    CategoryDB.instance.refreshUI();
    _amountEditing.text = widget.transactionModel.amount.toString();
    _purposeEditing.text = widget.transactionModel.purpose;
    _selectedDate = widget.transactionModel.date;
    _categoryModel = widget.transactionModel.category;
    _selectedCategorytype = widget.transactionModel.type;
   
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
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            height: 500,
            width: 365,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 227, 225, 225),
            ),
            child: Padding(
                padding: const EdgeInsets.all(9.0),
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Text('EDIT',
                            style: TextStyle(
                                fontWeight: FontWeight.w900, fontSize: 18)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: 150,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                              ),
                              child: Center(
                                child: DropdownButton<String>(
                                  hint: Text(
                                      widget.transactionModel.category.name,
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900)),
                                  value: categoryID,
                                  style: const TextStyle(color: Colors.green),
                                  underline: Container(),
                                  items: (_selectedCategorytype ==
                                              CategoryType.income
                                          ? CategoryDB().incomeCategoryList
                                          : CategoryDB().expenseCategoryList)
                                      .value
                                      .map((e) {
                                    return DropdownMenuItem(
                                      value: e.id,
                                      child: Text(e.name),
                                      onTap: () {
                                        _categoryModel = e;
                                      },
                                    );
                                  }).toList(),
                                  onChanged: (selectedValue) {
                                    setState(() {
                                      categoryID = selectedValue!;
                                    });
                                  },
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.white),
                                  iconEnabledColor: Colors.black,
                                ),
                              ),
                            ),
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
                                                const Duration(days: 30)),
                                            lastDate: DateTime.now());
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
                                      ? '$_selectedDate'
                                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}')),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text('AMOUNT',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _amountEditing,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Amount',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('PURPOSE',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: _purposeEditing,
                          maxLines: 5,
                          minLines: 3,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Purpose',
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: (() async {
                            await update(widget.index, widget.transactionModel.purpose);
                            }),
                            child: const Text(
                              'UPDATE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ]),
                ),),
          ),
        ),
      ),
    );
  }

  update(int index, String value) {
    final modelupdate = TransactionModel(
      amount: double.tryParse(_amountEditing.text)!,
      purpose: _purposeEditing.text,
      date: _selectedDate!,
      type: _selectedCategorytype!,
      category: _categoryModel!,
      id:widget.transactionModel.id
    
       
    );
    setState(() {
      TransactionDB.instance.updateTransaction(index,modelupdate);
    });

    setState(() {
      Navigator.of(context).pop();
    });

    showTopSnackBar(
        context,
        const CustomSnackBar.success(
            backgroundColor: Colors.purple, message: "Edit Successful"),
        displayDuration: const Duration(seconds: 2));
  }
}

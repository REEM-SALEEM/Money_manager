import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../Model/model/category/category_model.dart';
import '../../Model/model/transaction/transaction_model.dart';

class Total extends ChangeNotifier {
  double totalBalance = 0;
  double totalIncome = 0;
  double totalExpense = 0;

//*Amount calculation
  currentbalance(List<TransactionModel> value) {
    totalBalance = 0;
    totalIncome = 0;
    totalExpense = 0;

    for (TransactionModel value in value) {
      if (value.category.type == CategoryType.income) {
        totalIncome = totalIncome + value.amount;

        notifyListeners();
      }
      if (value.category.type == CategoryType.expense) {
        totalExpense = totalExpense + value.amount;
        notifyListeners();
      }
    }
    totalBalance = totalIncome - totalExpense;
    if (totalBalance < 0) {
      totalBalance = 0;
      notifyListeners();
    }
    notifyListeners();
  }
}

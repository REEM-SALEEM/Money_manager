import 'package:flutter/cupertino.dart';

import '../../Model/model/category/category_model.dart';
import '../../Model/model/transaction/transaction_model.dart';

class ProvChart extends ChangeNotifier {
  //-----------------------------------------------------------Overall Chart
  List<Overall> chartsort(List<TransactionModel> model) {
    double value;
    CategoryType categorytype;
    List visited = [];
    List<Overall> newData = [];

    for (var i = 0; i < model.length; i++) {
      visited.add(0);
    }

    for (var i = 0; i < model.length; i++) {
      value = model[i].amount;
      categorytype = model[i].category.type;

      for (var j = i + 1; j < model.length; j++) {
        if (model[i].category.type == model[j].category.type) {
          value = value + model[j].amount;
          visited[j] = -1;
        }
        notifyListeners();
      }

      if (visited[i] != -1) {
        newData.add(Overall(
          type: categorytype.name.toUpperCase(),
          amount: value,
        ));
        notifyListeners();
      }
    }
    notifyListeners();
    return newData;
  }
}

class Overall {
  Overall({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}

//-------------------------------------------------------------------Income chart
class Incchart extends ChangeNotifier {
  List<IncomeData> chartsort(List<TransactionModel> model) {
    double value;
    String categoryname;
    List visited = [];
    List<IncomeData> newData = [];

    for (var i = 0; i < model.length; i++) {
      visited.add(0);
    }

    for (var i = 0; i < model.length; i++) {
      if (model[i].category.type == CategoryType.income) {
        value = model[i].amount;
        categoryname = model[i].category.name;

        for (var j = i + 1; j < model.length; j++) {
          if (model[i].category.name == model[j].category.name) {
            value = value + model[j].amount;
            visited[j] = -1;
          }
        }

        if (visited[i] != -1) {
          newData.add(IncomeData(
            type: categoryname,
            amount: value,
          ));
        }
      }
    }

    return newData;
  }
}

class IncomeData {
  IncomeData({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}

//-------------------------------------------------------------------Expense chart
class Expchart extends ChangeNotifier {
//*Expense Chart
  List<ExpenseData> chartsort(List<TransactionModel> model) {
    double value;
    String categoryname;
    List visited = [];
    List<ExpenseData> newData = [];
//array cant be null.
    for (var i = 0; i < model.length; i++) {
      visited.add(0);
    }
//iterator will store the amt and catname to a variable
    for (var i = 0; i < model.length; i++) {
      if (model[i].category.type == CategoryType.expense) {
        value = model[i].amount;
        categoryname = model[i].category.name;

//compare with the ith index catname if yes add both amount together
        for (var j = i + 1; j < model.length; j++) {
          if (model[i].category.name == model[j].category.name) {
            value = value + model[j].amount;
            visited[j] = -1;
          }
        }
//storing in new aaray
        if (visited[i] != -1) {
          newData.add(ExpenseData(
            type: categoryname,
            amount: value,
          ));
        }
      }
    }

    return newData;
  }
}

class ExpenseData {
  ExpenseData({
    required this.type,
    required this.amount,
  });
  final String? type;
  final double amount;
}

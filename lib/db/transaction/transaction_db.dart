import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import '../../model/category/category_model.dart';
import '../../model/transaction/transaction_model.dart';

const TRANSACTIONS_DB_NAME = 'transactions_database';

abstract class TransactionDbFunctions {
  Future<List<TransactionModel>> getAllTransactions();
  Future<void> addTransaction(TransactionModel obj);
  Future<void> deleteTransaction(String transactionID);
  Future<void> updateTransaction(TransactionModel value);
  Future<void> transactionClear();
}

class TransactionDB implements TransactionDbFunctions {
  TransactionDB._internal(); //singleton obj(_internal)
  static TransactionDB instance = TransactionDB._internal();
  factory TransactionDB() {
    //factory: returns the existing object, if none is present will create one. (& to ensure)
    return instance;
  }

  ValueNotifier<List<TransactionModel>> transactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> incometransactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expensetransactionListNotifier =
      ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> filterListNotifier = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> incomeFilterlist = ValueNotifier([]);
  ValueNotifier<List<TransactionModel>> expenseFilterlist = ValueNotifier([]);

  @override
  Future<void> addTransaction(TransactionModel obj) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    await transactionDB.put(obj.id, obj);
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);

    return transactionDB.values.toList();
  }

  @override
  Future<void> updateTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    transactionDB.put(value.id, value);
    transactionListNotifier.value.clear();
    refresh();
  }

  Future<void> refresh() async {
    final list = await getAllTransactions();
    list.sort((first, second) => second.date.compareTo(first.date));

    expensetransactionListNotifier.value.clear();
    incometransactionListNotifier.value.clear();
    transactionListNotifier.value.clear();
    Future.forEach(
      list,
      (TransactionModel transaction) {
        if (transaction.type == CategoryType.income) {
          incometransactionListNotifier.value.add(transaction);
        } else {
          expensetransactionListNotifier.value.add(transaction);
        }
      },
    );
    filterListNotifier.notifyListeners();
    transactionListNotifier.value.clear();
    transactionListNotifier.value.addAll(list);
    transactionListNotifier.notifyListeners();
  }

  @override
  Future<void> deleteTransaction(String transactionID) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    transactionDB.delete(transactionID);
    refresh();
  }

  filterList(String selected) async {
    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (selected == 'Today') {
      return sortedList(today);
    } else if (selected == 'Yesterday') {
      return sortedList(yesterday);
    } else if (selected == 'Month') {
      return sortedMonth(today);
    }
  }

  DateTime? selected = DateTime.now();

//*Today & *Yesterday
  Future<void> sortedList(DateTime selectedCustomDate) async {
    incomeFilterlist.value.clear();
    expenseFilterlist.value.clear();
    filterListNotifier.value.clear();
    //Checks  iterated objects date.day and month == today and yesterday
    for (TransactionModel i in transactionListNotifier.value) {
      if (i.date.day == selectedCustomDate.day &&
          i.date.month == selected!.month &&
          i.type == CategoryType.income) {
        //if yes add it to income list and filter list
        incomeFilterlist.value.add(i);
        filterListNotifier.value.add(i);

        filterListNotifier.notifyListeners();
        incomeFilterlist.notifyListeners();
      } else if (i.date.day == selectedCustomDate.day &&
          i.date.month == selected!.month &&
          i.type == CategoryType.expense) {
        //if yes add it to expense list and filter list
        expenseFilterlist.value.add(i);
        filterListNotifier.value.add(i);

        filterListNotifier.notifyListeners();
        expenseFilterlist.notifyListeners();
      }
    }
  }

  sortedMonth(DateTime selectedCustomDate) async {
    incomeFilterlist.value.clear();
    expenseFilterlist.value.clear();
    filterListNotifier.value.clear();
    //Checks  iterated objects date.month == this month
    for (TransactionModel i in transactionListNotifier.value) {
      if (i.date.month == selectedCustomDate.month &&
          i.category.type == CategoryType.income) {
        //if yes add it to income list and filter list
        incomeFilterlist.value.add(i);
        filterListNotifier.value.add(i);

        incomeFilterlist.notifyListeners();
        filterListNotifier.notifyListeners();
      } else if (i.date.month == selectedCustomDate.month &&
          i.category.type == CategoryType.expense) {
        //if yes add it to expense list and filter list
        expenseFilterlist.value.add(i);
        filterListNotifier.value.add(i);

        expenseFilterlist.notifyListeners();
        filterListNotifier.notifyListeners();
      }
    }
  }

  @override
  Future<void> transactionClear() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(TRANSACTIONS_DB_NAME);
    await transactionDB.clear();
  }
}

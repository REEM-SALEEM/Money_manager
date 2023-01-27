import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:money_manager/Model/model/category/category_model.dart';
import 'package:provider/provider.dart';
import '../../Model/model/transaction/transaction_model.dart';

const transactionsdbname = 'transactions_database';

class ProvTransactionDB extends ChangeNotifier {
  List<TransactionModel> transactionListNotifier = [];
  List<TransactionModel> incometransactionListNotifier = [];
  List<TransactionModel> expensetransactionListNotifier = [];
  //
  List<TransactionModel> filterListNotifier = [];
  List<TransactionModel> incomeFilterlist = [];
  List<TransactionModel> expenseFilterlist = [];
  //
  TransactionModel? dat;
  DateTimeRange? newRange;
  DateTimeRange? picked;
  DateTime? startDate;
  DateTime? endDate;
  Future<void> addTransaction(TransactionModel obj) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionsdbname);
    await transactionDB.put(obj.id, obj);
    notifyListeners();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionsdbname);
    notifyListeners();
    return transactionDB.values.toList();
  }

  Future<void> updateTransaction(TransactionModel value) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionsdbname);
    transactionDB.put(value.id, value);
    transactionListNotifier.clear();
    refresh();
    notifyListeners();
  }

  Future<void> refresh() async {
    final list = await getAllTransactions();
    list.sort((first, second) => second.date.compareTo(first.date));

    expensetransactionListNotifier.clear();
    incometransactionListNotifier.clear();
    transactionListNotifier.clear();
    Future.forEach(
      list,
      (TransactionModel transaction) {
        if (transaction.type == CategoryType.income) {
          incometransactionListNotifier.add(transaction);
        } else {
          expensetransactionListNotifier.add(transaction);
        }
      },
    );
    // filterListNotifier.notifyListeners();
    transactionListNotifier.clear();
    transactionListNotifier.addAll(list);
    notifyListeners();
  }

  Future<void> deleteTransaction(String transactionID) async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionsdbname);
    transactionDB.delete(transactionID);
    refresh();
    notifyListeners();
  }

  //------------------Dropdown Overall
  filterCategory(String selected) async {
    incomeFilterlist.clear();
    expenseFilterlist.clear();
    filterListNotifier.clear();
    if (selected == 'Income') {
      for (TransactionModel i in transactionListNotifier) {
        if (i.type == CategoryType.income) {
          incomeFilterlist.add(i);
          filterListNotifier.add(i);
          notifyListeners();
        }
      }
    } else if (selected == 'Expense') {
      for (TransactionModel i in transactionListNotifier) {
        if (i.type == CategoryType.expense) {
          expenseFilterlist.add(i);
          filterListNotifier.add(i);
          notifyListeners();
        }
      }
    } else if (selected == 'Overall') {
      for (TransactionModel i in transactionListNotifier) {
        expenseFilterlist.add(i);
        filterListNotifier.add(i);
        notifyListeners();
      }
    }
  }

  //------------------------------------------Dropdown All
  filterList(String selected, BuildContext context) async {
    DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (selected == 'Today') {
      await Provider.of<ProvTransactionDB>(context, listen: false)
          .sortedList(today);
      notifyListeners();
    } else if (selected == 'Yesterday') {
      await Provider.of<ProvTransactionDB>(context, listen: false)
          .sortedList(yesterday);
      notifyListeners();
    }
  }

  DateTime? selected = DateTime.now();

  //*Today & *Yesterday
  Future<void> sortedList(DateTime selectedCustomDate) async {
    incomeFilterlist.clear();
    expenseFilterlist.clear();
    filterListNotifier.clear();
    //Checks  iterated objects date.day and month == today and yesterday
    for (TransactionModel i in transactionListNotifier) {
      if (i.date.day == selectedCustomDate.day &&
          i.date.month == selected!.month &&
          i.type == CategoryType.income) {
        //if yes add it to income list and filter list
        incomeFilterlist.add(i);
        filterListNotifier.add(i);

        notifyListeners();
      } else if (i.date.day == selectedCustomDate.day &&
          i.date.month == selected!.month &&
          i.type == CategoryType.expense) {
        //if yes add it to expense list and filter list
        expenseFilterlist.add(i);
        filterListNotifier.add(i);

        notifyListeners();
      }
    }
    notifyListeners();
  }

  //-----------------------------------------------up
  sortedCustom(DateTime startDate, DateTime endDate) async {
    incomeFilterlist.clear();
    expenseFilterlist.clear();
    filterListNotifier.clear();
    //
    for (TransactionModel i in transactionListNotifier) {
      if (i.date.day >= startDate.day &&
          i.date.day <= endDate.day &&
          i.date.month >= startDate.month &&
          i.date.month <= endDate.month &&
          i.category.type == CategoryType.income) {
        incomeFilterlist.add(i);
        filterListNotifier.add(i);
        notifyListeners();
      } //
      else if (i.date.day >= startDate.day &&
          i.date.day <= endDate.day &&
          i.date.month >= startDate.month &&
          i.date.month <= endDate.month &&
          i.category.type == CategoryType.expense) {
        expenseFilterlist.add(i);
        filterListNotifier.add(i);
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future<dynamic> selectDate(BuildContext context) async {
    //first date while we click custom
    final initialDate = DateTimeRange(
        start: DateTime.now().add(const Duration(days: -4)),
        end: DateTime.now());
    //picked date
    picked = (await showDateRangePicker(
      context: context,
      //if picked is null then will execute _initialDate
      initialDateRange: newRange ?? initialDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    ));

    if (picked == null) {
      return;
    } else {
      newRange = picked!;
      startDate = newRange!.start;
      endDate = newRange!.end;
    }
    Provider.of<ProvTransactionDB>(context, listen: false)
        .sortedCustom(startDate!, endDate!);
    picked == null;
    notifyListeners();
  }

  sortedMonth(String other) async {
    incomeFilterlist.clear();
    expenseFilterlist.clear();
    filterListNotifier.clear();
    for (TransactionModel i in transactionListNotifier) {
      if (i.date.month.toString() == other && i.type == CategoryType.income) {
        incomeFilterlist.add(i);
        filterListNotifier.add(i);
      } else if (i.date.month.toString() == other &&
          i.type == CategoryType.expense) {
        expenseFilterlist.add(i);
        filterListNotifier.add(i);
      }
    }
    notifyListeners();
  }

  Future<void> transactionClear() async {
    final transactionDB =
        await Hive.openBox<TransactionModel>(transactionsdbname);
    await transactionDB.clear();
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////
class ProvTRadio extends ChangeNotifier {
  CategoryType _selectedindexTab = CategoryType.income;
  get selectedCategorytype => _selectedindexTab;
  set selectedCategorytype(index) {
    _selectedindexTab = index;
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////
class ProvTCalender extends ChangeNotifier {
  DateTime? selectedDate;
  get date => selectedDate;
  set date(value) {
    selectedDate = value;
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////
class ProvTCategory extends ChangeNotifier {
  String? categoryID;
  get mon => categoryID;
  set mon(value) {
    categoryID = value;
    notifyListeners();
  }
}

/////////////////////////////////////////////////////////////////////////////////
class ProvTCategorytype extends ChangeNotifier {
  CategoryType sp = CategoryType.income;
  get selectedCategorytype => sp;
  set selectedCategorytype(value) {
    sp = value;
    notifyListeners();
  }
}

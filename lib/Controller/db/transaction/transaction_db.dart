// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/adapters.dart';
// import '../../../Model/model/transaction/transaction_model.dart';

// const transactionsdbname = 'transactions_database';

// abstract class TransactionDbFunctions {
//   // Future<List<TransactionModel>> getAllTransactions();
//   // Future<void> addTransaction(TransactionModel obj);
//   // Future<void> deleteTransaction(String transactionID);
//   // Future<void> updateTransaction(TransactionModel value);
//   Future<void> transactionClear();
// }

// class TransactionDB implements TransactionDbFunctions {
//   TransactionDB._internal(); //singleton obj(_internal)
//   static TransactionDB instance = TransactionDB._internal();
//   factory TransactionDB() {
//     //factory: returns the existing object, if none is present will create one. (& to ensure)
//     return instance;
//   }

//   ValueNotifier<List<TransactionModel>> transactionListNotifier =
//       ValueNotifier([]);
//   ValueNotifier<List<TransactionModel>> incometransactionListNotifier =
//       ValueNotifier([]);
//   ValueNotifier<List<TransactionModel>> expensetransactionListNotifier =
//       ValueNotifier([]);
//   // ValueNotifier<List<TransactionModel>> filterListNotifier = ValueNotifier([]);
//   // ValueNotifier<List<TransactionModel>> incomeFilterlist = ValueNotifier([]);
//   // ValueNotifier<List<TransactionModel>> expenseFilterlist = ValueNotifier([]);

//   // @override
//   // Future<void> addTransaction(TransactionModel obj) async {
//   //   final transactionDB =
//   //       await Hive.openBox<TransactionModel>(transactionsdbname);
//   //   await transactionDB.put(obj.id, obj);
//   // }

//   // @override
//   // Future<List<TransactionModel>> getAllTransactions() async {
//   //   final transactionDB =
//   //       await Hive.openBox<TransactionModel>(transactionsdbname);

//   //   return transactionDB.values.toList();
//   // }

//   // @override
//   // Future<void> updateTransaction(TransactionModel value) async {
//   //   final transactionDB =
//   //       await Hive.openBox<TransactionModel>(transactionsdbname);
//   //   transactionDB.put(value.id, value);
//   //   transactionListNotifier.value.clear();
//   //   // refresh();
//   // }

//   // Future<void> refresh() async {
//   //   final list = await getAllTransactions();
//   //   list.sort((first, second) => second.date.compareTo(first.date));

//   //   expensetransactionListNotifier.value.clear();
//   //   incometransactionListNotifier.value.clear();
//   //   transactionListNotifier.value.clear();
//   //   Future.forEach(
//   //     list,
//   //     (TransactionModel transaction) {
//   //       if (transaction.type == CategoryType.income) {
//   //         incometransactionListNotifier.value.add(transaction);
//   //       } else {
//   //         expensetransactionListNotifier.value.add(transaction);
//   //       }
//   //     },
//   //   );
//   //   filterListNotifier.notifyListeners();
//   //   transactionListNotifier.value.clear();
//   //   transactionListNotifier.value.addAll(list);
//   //   transactionListNotifier.notifyListeners();
//   // }

//   // @override
//   // Future<void> deleteTransaction(String transactionID) async {
//   //   final transactionDB =
//   //       await Hive.openBox<TransactionModel>(transactionsdbname);
//   //   transactionDB.delete(transactionID);
//   //   refresh();
//   // }

// //***Category filter
// //   filterCategory(String selected) async {
// //     incomeFilterlist.value.clear();
// //     expenseFilterlist.value.clear();
// //     filterListNotifier.value.clear();
// //     if (selected == 'Income') {
// //       for (TransactionModel i in transactionListNotifier.value) {
// //         if (i.type == CategoryType.income) {
// //           incomeFilterlist.value.add(i);
// //           filterListNotifier.value.add(i);
// //           incomeFilterlist.notifyListeners();
// //         }
// //       }
// //     } else if (selected == 'Expense') {
// //       for (TransactionModel i in transactionListNotifier.value) {
// //         if (i.type == CategoryType.expense) {
// //           expenseFilterlist.value.add(i);
// //           filterListNotifier.value.add(i);
// //           expenseFilterlist.notifyListeners();
// //         }
// //       }
// //     }
// //   }

// // //------------------------------------------aaaaaaaaaaallllllllllll
// //   filterList(String selected) async {
// //     DateTime now = DateTime.now();
// //     final today = DateTime(now.year, now.month, now.day);
// //     final yesterday = DateTime(now.year, now.month, now.day - 1);

// //     if (selected == 'Today') {
// //       return sortedList(today);
// //     } else if (selected == 'Yesterday') {
// //       return sortedList(yesterday);
// //     }
// //   }

// //   DateTime? selected = DateTime.now();

// // //*Today & *Yesterday
// //   Future<void> sortedList(DateTime selectedCustomDate) async {
// //     incomeFilterlist.value.clear();
// //     expenseFilterlist.value.clear();
// //     filterListNotifier.value.clear();
// //     //Checks  iterated objects date.day and month == today and yesterday
// //     for (TransactionModel i in transactionListNotifier.value) {
// //       if (i.date.day == selectedCustomDate.day &&
// //           i.date.month == selected!.month &&
// //           i.type == CategoryType.income) {
// //         //if yes add it to income list and filter list
// //         incomeFilterlist.value.add(i);
// //         filterListNotifier.value.add(i);

// //         filterListNotifier.notifyListeners();
// //         incomeFilterlist.notifyListeners();
// //       } else if (i.date.day == selectedCustomDate.day &&
// //           i.date.month == selected!.month &&
// //           i.type == CategoryType.expense) {
// //         //if yes add it to expense list and filter list
// //         expenseFilterlist.value.add(i);
// //         filterListNotifier.value.add(i);

// //         filterListNotifier.notifyListeners();
// //         expenseFilterlist.notifyListeners();
// //       }
// //     }
// //   }

// //   sortedCustom(DateTime startDate, DateTime endDate) async {
// //     incomeFilterlist.value.clear();
// //     expenseFilterlist.value.clear();
// //     filterListNotifier.value.clear();
// //     //
// //     for (TransactionModel i in transactionListNotifier.value) {
// //       if (i.date.day >= startDate.day &&
// //           i.date.day <= endDate.day &&
// //           i.date.month >= startDate.month &&
// //           i.date.month <= endDate.month &&
// //           i.category.type == CategoryType.income) {
// //         incomeFilterlist.value.add(i);
// //         filterListNotifier.value.add(i);
// //       } //
// //       else if (i.date.day >= startDate.day &&
// //           i.date.day <= endDate.day &&
// //           i.date.month >= startDate.month &&
// //           i.date.month <= endDate.month &&
// //           i.category.type == CategoryType.expense) {
// //         expenseFilterlist.value.add(i);
// //         filterListNotifier.value.add(i);
// //       }
// //     }
// //   }

//   @override
//   Future<void> transactionClear() async {
//     final transactionDB =
//         await Hive.openBox<TransactionModel>(transactionsdbname);
//     await transactionDB.clear();
//   }
// }

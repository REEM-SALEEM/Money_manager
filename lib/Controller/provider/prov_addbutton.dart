import 'package:flutter/cupertino.dart';
import 'package:money_manager/Controller/provider/prov_tot.dart';
import 'package:money_manager/Controller/provider/prov_transactions.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../Model/model/transaction/transaction_model.dart';

class ProvAddButton extends ChangeNotifier{
  //*Add Transaction details.
  Future<void> addTransaction(BuildContext context,_purpose,_amount,_selectedDate,selectedCategoryModel,_selectedCategorytype) async {
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
    // await TransactionDB.instance.addTransaction(model);
    Provider.of<ProvTransactionDB>(context, listen: false)
        .addTransaction(model);

    Navigator.of(context).pop();
    Provider.of<ProvTCalender>(context, listen: false).selectedDate = null;

    Provider.of<ProvTransactionDB>(context, listen: false).refresh();
    final nill = Provider.of<ProvTransactionDB>(context, listen: false)
        .transactionListNotifier;
     Provider.of<Total>(context, listen: false).currentbalance(Provider.of<ProvTransactionDB>(context, listen: false).transactionListNotifier);

    showTopSnackBar(
        context, const CustomSnackBar.success(message: "Data Entered"),
        displayDuration: const Duration(seconds: 2));
        notifyListeners();
  }
}
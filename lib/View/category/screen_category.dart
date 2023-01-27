import 'package:flutter/material.dart';
import 'package:money_manager/View/category/widgets/expense.dart';
import 'package:money_manager/View/category/widgets/income.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../Controller/provider/prov_categoryfunctions.dart';

class ScreenCategory extends StatelessWidget {
  const ScreenCategory({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProvFloating>(context, listen: false).indexTab = 0;
    });
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
                    child: Consumer<ProvFloating>(
                      builder: (BuildContext context, ProvFloating value,
                          Widget? child) {
                        int indexTab = 0;
                        return TabBar(
                            onTap: (index) async {
                              indexTab = index;
                              value.indexTab = indexTab;
                              // print(value.indexTab);
                              // print(indexTab);
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
                            ]);
                      },
                    ),
                  ),
                ),
                const SizedBox(
                    width: 400,
                    height: 507,
                    child: TabBarView(children: [Income(), Expense()]))
              ]),
            ),
          ),
          floatingActionButton: Consumer<ProvFloating>(
            builder: (BuildContext context, ProvFloating value, Widget? child) {
              return value.indexTab == 0
                  ? FloatingActionButton(
                      onPressed: () async {
                        await Provider.of<ProvPopup>(context, listen: false)
                            .showIncomepopup(context);
                        // showIncomepopup(context);
                      },
                      backgroundColor: Colors.black,
                      foregroundColor: const Color.fromARGB(255, 184, 252, 121),
                      child: const Icon(Icons.add, size: 30),
                    )
                  : FloatingActionButton(
                      onPressed: () async {
                        await Provider.of<ProvPopup>(context, listen: false)
                            .showExpensepopup(context);
                        // showExpensepopup(context);
                      },
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.orangeAccent,
                      child: const Icon(Icons.add, size: 30));
            },
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:money_manager/Controller/provider/prov_sharedpreference.dart';
import 'package:money_manager/View/screen_navbar.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ScreenWelcome extends StatelessWidget {
  ScreenWelcome({super.key});

//object created (a class that extends notify listeners).
  final TextEditingController _name = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(children: [
                        Container(
                          width: 85.w,
                          height: 310,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 184, 252, 121)
                                .withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(280.0),
                              bottomRight: Radius.circular(300.0),
                              bottomLeft: Radius.circular(300.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(100, 0, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                width: 71.9.w,
                                height: 35.h,
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(180.0),
                                    bottomRight: Radius.circular(200.0),
                                    bottomLeft: Radius.circular(200.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ]),
                SizedBox(height: 20.h),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Text(
                    'Welcome,',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _name, //get the value
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() == true) {
                              Provider.of<ProvGetnSet>(context, listen: false)
                                  .setNotesData(_name);
                                  // print(_name);
                                  // print(_name.text);

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BottomNavigationScreen(),
                                ),
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        ),
                        hintText: 'Enter Your Name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This is required';
                        } else if (value.length < 3) {
                          return 'Should contain minimum of 4 letters';
                        }
                        return null;
                      },
                    ),
                  ),
                )
              ]),
        ),
      ),
    );
  }
}

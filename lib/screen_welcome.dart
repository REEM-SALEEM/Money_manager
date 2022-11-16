import 'package:flutter/material.dart';
import 'package:money_manager/screen_navbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScreenWelcome extends StatefulWidget {
  const ScreenWelcome({super.key});

  @override
  State<ScreenWelcome> createState() => _ScreenWelcomeState();
}

class _ScreenWelcomeState extends State<ScreenWelcome> {
//object created (a class that extends notify listeners).
  final TextEditingController _name = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaquery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 42, 41),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Stack(children: [
                    Container(
                      width: 310,
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
                      padding: const EdgeInsets.fromLTRB(135, 0, 0, 0),
                      child: Container(
                        width: mediaquery.size.width * 0.62,
                        height: 250,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255)
                              .withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(180.0),
                            bottomRight: Radius.circular(200.0),
                            bottomLeft: Radius.circular(200.0),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ]),
                const SizedBox(height: 170),
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
                              setNotesData();

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const BottomNavigationScreen(),
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

//save name
  Future<void> setNotesData() async {
    final sharedprefs = await SharedPreferences
        .getInstance(); //initialize object of shared preference
    await sharedprefs.setString('saved_name', _name.text);
  }
}

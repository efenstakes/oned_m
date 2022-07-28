import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:jiffy/jiffy.dart';

class LoginScreen extends StatefulWidget {
  Function switchPage;
  LoginScreen({Key? key, required this.switchPage}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailInputController = TextEditingController();
  final TextEditingController _passwordInputController = TextEditingController();

  bool _isLoading = false;

  String _error = "";


  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: (screenSize.width/10)),
      child: Form(
        key: _formKey,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 560),
          child: ListView(
            children: [

              const SizedBox(height: 80),

              // title
              Text(
                "Login",
                style: Theme.of(context).textTheme.headline4!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 40),

              // Email
              TextFormField(
                controller: _emailInputController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter Email',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter email';
                  }
                  return null;
                },
                onSaved: (val)=> setState(() {
                  
                }),
              ),
              const SizedBox(height: 40),


              //passwordt
              TextFormField(
                controller: _passwordInputController,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Enter password',
                  prefixIcon: Icon(Icons.lock_open),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 3) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (val)=> setState(() {
                  
                }),
                obscureText: true,
              ),
              const SizedBox(height: 40),

              (_error == "" )
                ? Container()
                : 
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 20
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.yellow[200],
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Text(_error),
                  ),

              // add button
              FloatingActionButton.extended(
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                onPressed: _login, 
                label: Text(
                  _isLoading ? "Logging in.." : "Login"
                ),
                icon: _isLoading ? CircularProgressIndicator() : null,
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: ()=> widget.switchPage(), child: Text("No Account? Create One"),),

              const SizedBox(height: 80),

            ],
          ),
        ),
      ),
    );
  }


  _login() async {
    _formKey.currentState!.save();

    if( !_formKey.currentState!.validate() ) {
      print("form error ");
      return;
    }

    setState(() {
      _isLoading = true;
      _error = "";
    });

    print("form can submit");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailInputController.text.trim(), 
        password: _passwordInputController.text.trim()
      );
    } on FirebaseAuthException catch (e) {
      print("\n\n\n");
      print("could not login ${e.code}");
      print("\n\n\n");
      switch (e.code) {
        case "invalid-email":
          setState(()=> _error = "Check email and password");
          break;

        case "user-disabled":
          setState(()=> _error = "Check email and password");
          break;
          
        case "user-not-found":
          setState(()=> _error = "Check email and password");
          break;
          
        case "wrong-password":
          setState(()=> _error = "Check email and password");
          break;

        default:
      }
    }

    setState(()=> _isLoading = true);
  }
}
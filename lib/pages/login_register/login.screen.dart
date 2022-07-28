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




  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: (screenSize.width/10)),
      child: Form(
        key: _formKey,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 100),
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


              // add button
              FloatingActionButton.extended(
                elevation: 0,
                focusElevation: 0,
                hoverElevation: 0,
                onPressed: (){
                  _formKey.currentState!.save();

                  if( !_formKey.currentState!.validate() ) {
                    print("form error ");
                    return;
                  }

                  print("form can submit");

                  try {
                    FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailInputController.text.trim(), 
                      password: _passwordInputController.text.trim()
                    );
                  } catch(e) {
                    print("could not login ${e.toString()}");
                  }

                }, 
                label: Text("Login"),
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
}
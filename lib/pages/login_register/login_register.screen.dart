import 'package:flutter/cupertino.dart';
import 'package:oned_m/pages/login_register/create_account.screen.dart';
import 'package:oned_m/pages/login_register/login.screen.dart';


class LoginRegisterScreen extends StatefulWidget {
  const LoginRegisterScreen({Key? key}) : super(key: key);

  @override
  State<LoginRegisterScreen> createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {

  bool _isInLogging = true;




  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isInLogging ? LoginScreen(switchPage: switchPage,) : CreateAccountScreen(switchPage: switchPage,),
    );
  }

  switchPage() {
    setState(() {
      _isInLogging = !_isInLogging;
    });
  }
}
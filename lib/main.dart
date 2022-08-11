import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:oned_m/pages/login_register/login_register.screen.dart';
import 'package:oned_m/pages/menu/menu.screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var firebaseConfig = {
      'apiKey': "AIzaSyAtAQ3TOnKpDEAbggfCA-bxzCL1EhAQrrU",
      'authDomain': "oned-10ebb.firebaseapp.com",
      'projectId': "oned-10ebb",
      'storageBucket': "oned-10ebb.appspot.com",
      'messagingSenderId': "497691951085",
      'appId': "1:497691951085:web:02d440bb9e2e461a1071e4",
      'measurementId': "G-76X291NYW0"
  };
  try {
     await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: firebaseConfig['apiKey']!, 
        appId: firebaseConfig['appId']!, 
        messagingSenderId: firebaseConfig['messagingSenderId']!, 
        projectId: firebaseConfig['projectId']!
      )
    );
  } catch(e) {

  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OneD M',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {

          if( snapshot.hasData ) {
            return const MenuScreen();
          }

          return const LoginRegisterScreen();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51JP6JmI4ViauatGSX8QA0chQ5RWtjTRATjirbuDlQbpfwm8NJxKR9kVkuuND0RRWSSGkCBafYlNcXfDFrpFoMr7y00Ip7D03Od';
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const Dashboard());
  }
}

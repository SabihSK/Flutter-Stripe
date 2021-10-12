// ignore_for_file: prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print("Pay Amount");
              openCheckoutCard(
                  10000,
                  '0.0',
                  '0239239839',
                  'companyName',
                  'GBP',
                  'sk_test_51JP6JmI4ViauatGSdJUJ3clFsqhM3mlJIrSgqWWBozuoluHxAG2hH9BzAnb9CjICcyDQtCqMgyfwWAAg3ZidfefA005Wu27Imu',
                  (p0) => null);
            },
            child: Text("Pay Amount"),
          ),
        ),
      ),
    );
  }

  // Future<void> makePayment() async {
  //   final url = Uri.parse(uri);
  // }

  Future<Map<String, dynamic>?> createPaymentIntent(
      String amount, String currency, String stripeSecret) async {
    try {
      Map<String, String> requestHeaders = {
        'Content-type': 'application/x-www-form-urlencoded',
        'Authorization': "Bearer $stripeSecret",
      };
      Map<String, dynamic> body = {
        "amount": amount,
        "currency": currency,
        "payment_method_types[]": "card"
      };
      var url = "https://api.stripe.com/v1/payment_intents";
      var response = await http
          .post(Uri.parse(url), headers: requestHeaders, body: body)
          .timeout(const Duration(seconds: 10));
      log(url);
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
      return json.decode(response.body);
    } catch (ex) {
      print(ex.toString());
    }
    return null;
  }

  //!-=----------

  Future<bool> openCheckoutCard(
      int amount,
      String desc,
      String clientPhone,
      String companyName,
      String currency,
      String stripeSecret,
      Function(String) onSuccess) async {
    try {
      Map<String, dynamic>? paymentIntent =
          await createPaymentIntent(amount.toString(), currency, stripeSecret);
      if (paymentIntent == null) return false;
      log(paymentIntent.toString());

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          applePay: true,
          googlePay: true,
          style: ThemeMode.dark,
          testEnv: true,
          // merchantCountryCode: 'UK',
          // merchantDisplayName: 'Stripe Store Demo',
          customerId: paymentIntent['customer'],
          paymentIntentClientSecret: paymentIntent['client_secret'],
          // customerEphemeralKeySecret: paymentIntent['ephemeralKey'],
        ),
      );

      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntent['client_secret'],
        confirmPayment: true,
      ));
      print("Payment $currency${amount / 100} stripe:${paymentIntent["id"]}");
      onSuccess(
          "Payment $currency${amount / 100} stripe:${paymentIntent["id"]}");
      return true;
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}

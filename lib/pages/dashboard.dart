import 'package:cryptonian/functions/send_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final apiKey = '5813e242-4a9d-45be-89bd-bc7b2fb293bf';
  String cryptoSymbol = '';
  double thresholdPrice = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Price Checker'),
        actions: [
          GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter cryptocurrency symbol',
              ),
              onChanged: (value) {
                setState(() {
                  cryptoSymbol = value.toUpperCase();
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Enter price threshold',
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                setState(() {
                  thresholdPrice = double.tryParse(value) ?? 0.0;
                });
              },
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              child: const Text('Get Notified'),
              onPressed: () {
                print("000000000000");
                startPriceChecker(cryptoSymbol, thresholdPrice);
              },
            ),
            ElevatedButton(onPressed: () {}, child: Text("send mail"))
          ],
        ),
      ),
    );
  }

  void startPriceChecker(String cryptoSymbol, double thresholdPrice) {
    print("0000000000000000000 fuction called");
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      print("0000000000000000 indise");
      final apiUrl =
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=$cryptoSymbol';

      final response = await http.get(Uri.parse(apiUrl), headers: {
        'X-CMC_PRO_API_KEY': apiKey,
      });

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("00000000000000000 $jsonResponse");
        final cryptoPrice =
            jsonResponse['data'][cryptoSymbol]['quote']['USD']['price'];

        if (cryptoPrice > thresholdPrice) {
          print("000000000000000000000000000Hello!");
          sendEmail(
            currency: cryptoSymbol,
            subject:
                "$cryptoSymbol is going up then your threshold of $thresholdPrice",
          );
        }
      } else {
        print(
            "0000000000000000 Failed to retrieve crypto price. Status code: ${response.statusCode}");
      }
    });
  }
}

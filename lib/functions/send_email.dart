import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

String getUser() {
  String user_mail = "";
  final currentUser = FirebaseAuth.instance.currentUser;

  print("0000000000000000 ${currentUser?.email}");
  if (currentUser != null) {
    user_mail = currentUser.email!;
  }
  return user_mail;
}

Future sendEmail({
  required currency,
  required subject,
}) async {
  final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
  String user_email = getUser() as String;
  final response = await http.post(url,
      headers: {
        "origin": "http://localhost",
        "Content-Type": 'application/json'
      },
      body: json.encode({
        "service_id": 'service_x1kpqyb',
        "template_id": 'template_m5q6oob',
        "user_id": 'G66tE7RX2A6DtpIsk',
        "template_params": {
          "user_subject": "$currency is going up",
          "user_message": subject,
          "user_name": "Cryptonian",
          "reply_email": "Cryptonian@gamil.com",
          "user_email": user_email
        }
      }));

  print("0000000000000 ${response.body}");
}

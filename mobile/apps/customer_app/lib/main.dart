import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  const apiBaseUrl = String.fromEnvironment('KONFRM_API_BASE_URL');
  runApp(KonfrmCustomerApp(apiBaseUrl: apiBaseUrl));
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/globalCalendarScreen.dart';
import 'sign_in_flow/auth_state_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    AuthStateSwitch(
      app: GlobalCalendarScreen(),
    ),
  );
}

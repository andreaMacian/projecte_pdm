import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/screens/structureApp.dart';

import 'sign_in_flow/auth_state_switch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    AuthStateSwitch(
      app: StructureApp(),
    ),
  );
}

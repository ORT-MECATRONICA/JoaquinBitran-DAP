import 'package:final_project_firebase/core/go_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

// Sources for code
// https://stackoverflow.com/questions/58383016/how-to-update-field-in-document-on-cloud-firestore-using-flutter
// https://www.youtube.com/watch?v=KLDVXaTPa5E&t=6s
// https://www.youtube.com/watch?v=COZ67pwhguY
// https://youtu.be/rWamixHIKmQ?si=BSk2PVvu1xRPr1hn
// https://www.youtube.com/watch?v=6Vc_E20o5wE

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

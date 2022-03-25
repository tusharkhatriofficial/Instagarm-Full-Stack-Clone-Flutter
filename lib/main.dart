import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:instagram_ui_backend_clone/providers/user_provider.dart';
import 'package:instagram_ui_backend_clone/responsive/mobile_screen_layout.dart';
import 'package:instagram_ui_backend_clone/responsive/responsive_layout_screen.dart';
import 'package:instagram_ui_backend_clone/responsive/web_screen_layout.dart';
import 'package:instagram_ui_backend_clone/screens/comments_screen.dart';
import 'package:instagram_ui_backend_clone/screens/login_screen.dart';
import 'package:instagram_ui_backend_clone/screens/signup_screen.dart';
import 'package:instagram_ui_backend_clone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDuHJad8G0KwAYaKr19Kv8MOqSqwYUo78A",
        appId: "1:1014020396252:web:a56c8c610be33658d8d019",
        messagingSenderId: "1014020396252",
        projectId: "instagram-clone-dba0c",
        storageBucket: "instagram-clone-dba0c.appspot.com",
        measurementId: "G-MPDX5VLT5H",
        authDomain: "instagram-clone-dba0c.firebaseapp.com",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: kMobileBackgroundColor,
        ),
        routes: {
          '/login': (context) => LoginScreen(),
          '/signup': (context) => SignupScreen(),
          // '/comments_screen': (context) => CommentsScreen(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  color: kPrimaryColor,
                ),
              );
            }
            return LoginScreen();
          },
        ),
      ),
    );
  }
}

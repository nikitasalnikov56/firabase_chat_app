import 'package:firebase_chat_app/domain/provider/chat_provider.dart';
import 'package:firebase_chat_app/domain/provider/getuserdata_provider.dart';
import 'package:firebase_chat_app/ui/routes/app_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => GetUserDataProvider(),
        ),
      ],
      child: MaterialApp.router(
        // theme: ThemeData(useMaterial3: false),
        debugShowCheckedModeBanner: false,
        routerConfig: AppNavigator.router,
      ),
    );
  }
}

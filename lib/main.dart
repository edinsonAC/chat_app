import 'package:chat_app/routes/routes.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/sockect_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => AuthService()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SocketService()),
        ChangeNotifierProvider(create: (BuildContext context) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat App',
        initialRoute: 'loader',
        routes: appRoutes,
      ),
    );
  }
}

import 'dart:io';

class Environment {
  // https://backend-chat-flutter-test.herokuapp.com/
  // static String apiUrl = Platform.isAndroid
  //     ? 'http://192.168.0.18:3000/api'
  //     : 'http://localhost:3000/api';
  static String apiUrl = 'https://backend-chat-flutter-test.herokuapp.com/api';

  // static String sockectUrl =
  //     Platform.isAndroid ? 'http://192.168.0.18:3000' : 'http://localhost:3000';
  static String sockectUrl = 'https://backend-chat-flutter-test.herokuapp.com';
}

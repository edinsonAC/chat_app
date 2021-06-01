import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String texto;
  final String uid;
  final AnimationController animationController;
  final DateTime tiempo;
  final bool manual;
  // this.authService.usuario.uid

  const ChatMessage(
      {Key key,
      @required this.texto,
      @required this.uid,
      @required this.tiempo,
      this.manual,
      @required this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
            parent: animationController, curve: Curves.easeInOut),
        child: Container(
          child: this.uid == authService.usuario.uid
              ? _myMessage()
              : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff4D9EF6),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(20))),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.texto,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            Text(
              DateFormat('kk:mm').format(this.tiempo.toLocal()),
              style: TextStyle(color: Colors.black38, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.purple[500],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomRight: Radius.circular(10),
                topRight: Radius.circular(10))),
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(bottom: 5, left: 3, right: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              this.texto,
              style: TextStyle(color: Colors.white),
            ),
            Text(
              DateFormat('hh:mm').format(this.tiempo.toLocal()),
              style: TextStyle(color: Colors.black38, fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}

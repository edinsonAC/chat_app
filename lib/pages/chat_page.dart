import 'dart:io';

import 'package:chat_app/models/mensaje_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/sockect_services.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = new FocusNode();
  ChatService chatService;
  SocketService socketService;
  AuthService authService;
  List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(this.chatService.usuarioPara.uid);
  }

  void _cargarHistorial(String usId) async {
    List<Mensaje> chat = await this.chatService.getChat(usId);
    print(chat);
    final history = chat.map((e) => new ChatMessage(
        texto: e.mensaje,
        uid: e.de,
        tiempo: e.createdAt,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 500))
          ..forward()));

    setState(() {
      this._messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage newMessage = new ChatMessage(
      texto: data['mensaje'],
      uid: data['de'],
      tiempo: new DateTime.now(),
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );
    setState(() {
      _messages.insert(0, newMessage);
    });
    newMessage.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usPara = this.chatService.usuarioPara;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.black87,
        centerTitle: true,
        title: Row(
          children: [
            CircleAvatar(
              maxRadius: 20,
              child: Text(usPara.nombre.substring(0, 2),
                  style: TextStyle(fontSize: 12, color: Colors.white)),
              backgroundColor: Colors.blueAccent,
            ),
            SizedBox(
              width: 3,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  usPara.nombre,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                usPara.online
                    ? Text(
                        'En línea',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      )
                    : SizedBox(),
              ],
            )
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.black87),
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) => _messages[i])),
            Divider(
              height: 1,
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
              child: TextField(
            scrollPadding: EdgeInsets.all(10),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: _textController,
            onSubmitted: _handleSubmit,
            onChanged: (String text) {
              setState(() {
                if (text.trim().length > 0) {
                  _isWriting = true;
                } else {
                  _isWriting = false;
                }
              });
            },
            decoration: InputDecoration(
              hintText: 'Enviar mensaje',
              border: InputBorder.none,
            ),
            focusNode: _focusNode,
          )),
          //boton
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: Platform.isIOS
                ? CupertinoButton(
                    child: Text('Enviar'),
                    onPressed: _isWriting
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.0),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: Icon(Icons.send),
                        onPressed: _isWriting
                            ? () => _handleSubmit(_textController.text.trim())
                            : null,
                      ),
                    ),
                  ),
          )
        ],
      ),
    ));
  }

  _handleSubmit(String texto) {
    if (texto.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();
    final newMessage = new ChatMessage(
      texto: texto,
      uid: this.authService.usuario.uid,
      tiempo: DateTime.now(),
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 500)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _isWriting = false;
    });
    this.socketService.socket.emit('mensaje-personal', {
      'de': this.authService.usuario.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    // TODO: off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    this.socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}

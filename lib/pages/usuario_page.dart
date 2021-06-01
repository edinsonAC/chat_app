import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/push/push_notification.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_services.dart';
import 'package:chat_app/services/sockect_services.dart';
import 'package:chat_app/services/usuario_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuarioPage extends StatefulWidget {
  @override
  _UsuarioPageState createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final usuarioService = new UsuarioService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    this._cargarUsuarios();
    super.initState();
    final _pushProvider = new PushNotificationProvider();
    _pushProvider.initNotification();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    final usuario = authService.usuario;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            usuario.nombre,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 1,
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(Icons.exit_to_app, color: Colors.white),
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.blue[400],
                    )
                  : Icon(
                      Icons.offline_bolt,
                      color: Colors.red[400],
                    ),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: _cargarUsuarios,
          enablePullDown: true,
          header: WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue[400]),
            waterDropColor: Colors.blue[400],
          ),
          child: _listViewUsuario(),
        ));
  }

  ListView _listViewUsuario() {
    return ListView.separated(
        physics: BouncingScrollPhysics(),
        itemBuilder: (_, i) => _usuarioTile(usuarios[i]),
        separatorBuilder: (_, i) => Divider(),
        itemCount: usuarios.length);
  }

  ListTile _usuarioTile(Usuario us) {
    return ListTile(
      title: Text(
        us.nombre,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
      ),
      subtitle: Text(us.email),
      leading: CircleAvatar(
        maxRadius: 30,
        child: Text(us.nombre.substring(0, 2)),
      ),
      trailing: Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(
            color: us.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        print(us);
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = us;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}

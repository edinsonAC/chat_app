
import "package:flutter/material.dart";
import 'package:chat_app/pages/usuario_page.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/sockect_services.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class ColorLoader extends StatefulWidget {
  final double radius;
  final double dotRadius;

  ColorLoader({this.radius = 30.0, this.dotRadius = 3.0});

  @override
  _ColorLoaderState createState() => _ColorLoaderState();
}

class _ColorLoaderState extends State<ColorLoader>
    with SingleTickerProviderStateMixin {
  Animation<double> animationRotation;
  Animation<double> animationRadiusIn;
  Animation<double> animationRadiusOut;
  AnimationController controller;

  double radius;
  double dotRadius;

  @override
  void initState() {
    super.initState();
    radius = widget.radius;
    dotRadius = widget.dotRadius;
    controller = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 3000),
        vsync: this);

    animationRotation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 1.0, curve: Curves.linear),
      ),
    );

    animationRadiusIn = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.75, 1.0, curve: Curves.elasticIn),
      ),
    );

    animationRadiusOut = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0.0, 0.25, curve: Curves.elasticOut),
      ),
    );

    controller.addListener(() {
      setState(() {
        if (controller.value >= 0.75 && controller.value <= 1.0)
          radius = widget.radius * animationRadiusIn.value;
        else if (controller.value >= 0.0 && controller.value <= 0.25)
          radius = widget.radius * animationRadiusOut.value;
      });
    });

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {}
    });

    controller.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: checkLoginState(context),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              return Container(
                decoration: BoxDecoration(color: Colors.black87),
                width: double.infinity,
                height: double.infinity,
                //color: Colors.black12,
                child: new Center(
                  child: new RotationTransition(
                    turns: animationRotation,
                    child: new Container(
                      //color: Colors.limeAccent,
                      child: new Center(
                        child: Stack(
                          children: <Widget>[
                            new Transform.translate(
                              offset: Offset(0.0, 0.0),
                              child: Dot(
                                radius: radius,
                                color: Colors.purple,
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0),
                                radius * sin(0.0),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 1 * pi / 4),
                                radius * sin(0.0 + 1 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 2 * pi / 4),
                                radius * sin(0.0 + 2 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 3 * pi / 4),
                                radius * sin(0.0 + 3 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 4 * pi / 4),
                                radius * sin(0.0 + 4 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 5 * pi / 4),
                                radius * sin(0.0 + 5 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 6 * pi / 4),
                                radius * sin(0.0 + 6 * pi / 4),
                              ),
                            ),
                            new Transform.translate(
                              child: Dot(
                                radius: dotRadius,
                                color: Colors.blue,
                              ),
                              offset: Offset(
                                radius * cos(0.0 + 7 * pi / 4),
                                radius * sin(0.0 + 7 * pi / 4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      //socket server
      // Navigator.pushReplacementNamed(context, 'usuarios');
      socketService.connect();
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => UsuarioPage(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacementNamed(context, 'login');

      // socketService.disconnect();
      // Navigator.pushReplacement(
      //     context,
      //     PageRouteBuilder(
      //         pageBuilder: (_, __, ___) => LoginPage(),
      //         transitionDuration: Duration(milliseconds: 0)));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  Dot({this.radius, this.color});

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Container(
        width: radius + 10,
        height: radius + 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

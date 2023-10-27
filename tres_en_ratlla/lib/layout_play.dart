import 'dart:async';
import 'package:provider/provider.dart';
import 'widget_tresratlla.dart';
import 'app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LayoutPlay extends StatefulWidget {
  const LayoutPlay({Key? key}) : super(key: key);

  @override
  LayoutPlayState createState() => LayoutPlayState(AppData as AppData);
}

class LayoutPlayState extends State<LayoutPlay> {
  final AppData appData;
  late int secondsElapsed;
  late Timer timer;
  LayoutPlayState(this.appData);

  @override
  void initState() {
    super.initState();
    secondsElapsed = 0;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        secondsElapsed++;
      });
      if (gameOverConditionMet()) {
        timer?.cancel();
      }
    });
  }

  bool gameOverConditionMet() {
    final appData = Provider.of<AppData>(context, listen: false);
    return appData.gameIsOver;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String getFormattedTime() {
    final minutes = (secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsElapsed % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          "BUSCAMINAS",
          style: TextStyle(
            fontSize: 28,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.blue,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 700,
                height: 639,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 3.0,
                  ),
                ),
                child: WidgetTresRatlla(),
              ),
              Column(
                children: <Widget>[
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 41, 44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "TIEMPO",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // Ajusta el espacio vertical aquí
                          ),
                          child: Text(
                            getFormattedTime(),
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 41, 44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "BOMBAS",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // Ajusta el espacio vertical aquí
                          ),
                          child: Text(
                            appData.minas
                                .toString(), // Reemplaza con la cantidad real de bombas
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 150,
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 39, 41, 44),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "BANDERAS",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 20, // Ajusta el espacio vertical aquí
                          ),
                          child: Text(
                            "5", // Reemplaza con la cantidad real de banderas
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

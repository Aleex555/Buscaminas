import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'app_data.dart';

class LayoutSettings extends StatefulWidget {
  const LayoutSettings({Key? key}) : super(key: key);

  @override
  LayoutSettingsState createState() => LayoutSettingsState();
}

class LayoutSettingsState extends State<LayoutSettings> {
  List<String> tableros = ["9x9", "15x15"];
  List<int> minas = [5, 10, 15];

  // Mostrar el CupertinoPicker en un diálogo.
  void _showPicker(String type) {
    List<dynamic> options = type == "player" ? tableros : minas;
    String title = type == "player"
        ? "Selecciona el tablero"
        : "Selecciona la cantidad de minas";

    // Encontrar el índice de la opción actual en la lista de opciones
    AppData appData = Provider.of<AppData>(context, listen: false);
    dynamic currentValue = type == "player" ? appData.tablero : appData.minas;
    int currentIndex = options.indexOf(currentValue);
    FixedExtentScrollController scrollController =
        FixedExtentScrollController(initialItem: currentIndex);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground
                  .resolveFrom(context),
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SafeArea(
                top: false,
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  scrollController: scrollController,
                  onSelectedItemChanged: (index) {
                    if (type == "player") {
                      appData.tablero = options[index];
                      appData.numero =
                          int.parse(appData.tablero.split('x').first);
                    } else if (type == "minas") {
                      appData.minas = options[index];
                      appData.numFlags = options[index];
                    }
                    setState(() {});
                  },
                  children: options
                      .map((option) => Center(child: Text(option.toString())))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppData appData = Provider.of<AppData>(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Configuració"),
        leading: CupertinoNavigationBarBackButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Elige el tamaño del tablero: "),
              CupertinoButton(
                onPressed: () => _showPicker("player"),
                child: Text(appData.tablero),
              )
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text("Elige la cantidad de minas: "),
              CupertinoButton(
                onPressed: () => _showPicker("minas"),
                child: Text(appData.minas.toString()),
              )
            ]),
          ],
        ),
      ),
    );
  }
}

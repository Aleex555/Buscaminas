import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class AppData with ChangeNotifier {
  // App status
  String tablero = "9x9"; // Opción predeterminada
  int numero = 9;
  int minas = 5;

  List<List<String>> board = [];
  bool gameIsOver = false;
  String gameWinner = '-';

  ui.Image? imagePlayer;
  ui.Image? imageOpponent;
  bool imagesReady = false;

  List<List<String>> addRandomBs(List<List<String>> board, int numBs) {
    final numRows = board.length;
    final numCols = board[0].length;

    if (numBs > numRows * numCols) {
      print("El número de 'b's a añadir es mayor que el tamaño del tablero.");
      return board;
    }

    final updatedBoard = List<List<String>>.from(board);
    int addedBs = 0;
    final random = Random();

    while (addedBs < numBs) {
      final row = random.nextInt(numRows);
      final col = random.nextInt(numCols);

      if (updatedBoard[row][col] == '-') {
        updatedBoard[row][col] = 'b';
        addedBs++;
      }
    }

    return updatedBoard;
  }

  void resetGame() {
    if (numero == 9) {
      board = [
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
        ['-', '-', '-', '-', '-', '-', '-', '-', '-'],
      ];
      board = addRandomBs(board, minas);
    } else if (numero == 15) {
      board = [
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
        [
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-',
          '-'
        ],
      ];
      board = addRandomBs(board, minas);
      for (var row in board) {
        print(row.join(' '));
      }
    }

    gameIsOver = false;
    gameWinner = '-';
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    if (board[row][col] == '-') {
      board[row][col] = 'X';
      checkGameWinner();
      if (gameWinner == '-') {
        machinePlay();
      }
    }
    if (board[row][col] == 'b') {
      print("BOOOOM");
      checkGameWinner();
      if (gameWinner == '-') {
        machinePlay();
      }
    }
  }

  // Fa una jugada de la màquina, només busca la primera posició lliure
  void machinePlay() {
    bool moveMade = false;

    // Buscar una casella lliure '-'
    for (int i = 0; i < numero; i++) {
      for (int j = 0; j < numero; j++) {
        if (board[i][j] == '-') {
          board[i][j] = 'O';
          moveMade = true;
          break;
        }
      }
      if (moveMade) break;
    }

    checkGameWinner();
  }

  // Comprova si el joc ja té un tres en ratlla
  // No comprova la situació d'empat
  void checkGameWinner() {
    for (int i = 0; i < 3; i++) {
      // Comprovar files
      if (board[i][0] == board[i][1] &&
          board[i][1] == board[i][2] &&
          board[i][0] != '-') {
        gameIsOver = true;
        gameWinner = board[i][0];
        return;
      }

      // Comprovar columnes
      if (board[0][i] == board[1][i] &&
          board[1][i] == board[2][i] &&
          board[0][i] != '-') {
        gameIsOver = true;
        gameWinner = board[0][i];
        return;
      }
    }

    // Comprovar diagonal principal
    if (board[0][0] == board[1][1] &&
        board[1][1] == board[2][2] &&
        board[0][0] != '-') {
      gameIsOver = true;
      gameWinner = board[0][0];
      return;
    }

    // Comprovar diagonal secundària
    if (board[0][2] == board[1][1] &&
        board[1][1] == board[2][0] &&
        board[0][2] != '-') {
      gameIsOver = true;
      gameWinner = board[0][2];
      return;
    }

    // No hi ha guanyador, torna '-'
    gameWinner = '-';
  }

  // Carrega les imatges per dibuixar-les al Canvas
  Future<void> loadImages(BuildContext context) async {
    // Si ja estàn carregades, no cal fer res
    if (imagesReady) {
      notifyListeners();
      return;
    }

    // Força simular un loading
    await Future.delayed(const Duration(milliseconds: 500));

    Image tmpPlayer = Image.asset('assets/images/player.png');
    Image tmpOpponent = Image.asset('assets/images/opponent.png');

    // Carrega les imatges
    if (context.mounted) {
      imagePlayer = await convertWidgetToUiImage(tmpPlayer);
    }
    if (context.mounted) {
      imageOpponent = await convertWidgetToUiImage(tmpOpponent);
    }

    imagesReady = true;

    // Notifica als escoltadors que les imatges estan carregades
    notifyListeners();
  }

  // Converteix les imatges al format vàlid pel Canvas
  Future<ui.Image> convertWidgetToUiImage(Image image) async {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (info, _) => completer.complete(info.image),
          ),
        );
    return completer.future;
  }
}

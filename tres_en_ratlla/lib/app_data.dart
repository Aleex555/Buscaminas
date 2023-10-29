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
  List<List<int>> bombLocations = [];
  List<List<int>> flagsLocations = [];
  bool gameIsOver = false;
  String gameWinner = '-';
  int numFlags = 5;

  ui.Image? image1;
  ui.Image? imageBandera;
  ui.Image? bomba;
  ui.Image? image2;
  ui.Image? image3;
  ui.Image? image4;
  ui.Image? imageCuadrado;
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
      bombLocations.add([row, col]);

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
      for (var row in board) {
        print(row.join(' '));
      }
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
      for (var row in board) {
        print(row.join(' '));
      }
    }
    gameIsOver = false;
    gameWinner = '-';
    numFlags = minas;
  }

  // Fa una jugada, primer el jugador després la maquina
  void playMove(int row, int col) {
    bool terminar = true;
    if (board[row][col] == '-') {
      revealCell(row, col);
    }
    if (board[row][col] == 'b') {
      board[row][col] = 'x';
      gameWinner = "Has explotado una bomba";
    }
    for (int i = 0; i < board.length; i++) {
      for (int j = 0; j < board[i].length; j++) {
        if (board[i][j] == '-') {
          terminar = false;
          break;
        }
      }
    }
    if (terminar) {
      gameWinner = "Has Ganado";
    }

    for (var row in board) {
      print(row.join(' '));
    }
  }

  void flags(int row, int col) {
    if ((board[row][col] != 'f' && board[row][col] == '-') ||
        (board[row][col] != 'f' && board[row][col] == 'b')) {
      if (numFlags == 0) {
        return;
      } else if (board[row][col] == 'b') {
        board[row][col] = 'bf';
        numFlags--;
      } else {
        board[row][col] = 'f';
        flagsLocations.add([row, col]);
        numFlags--;
      }
    } else if (board[row][col] == 'bf') {
      flagsLocations.remove([row, col]);
      board[row][col] = 'b';
      numFlags++;
    } else {
      board[row][col] = '-';
      flagsLocations.remove([row, col]);
      numFlags++;
    }

    for (var row in board) {
      print(row.join(' '));
    }
    print(numFlags);
  }

  void revealCell(int row, int col) {
    if (gameIsOver || board[row][col] != '-') {
      return; // No puedes descubrir una casilla que ya ha sido revelada o que contiene una bomba
    }
    int bombCount = countAdjacentBombs(row, col);
    board[row][col] = bombCount.toString();

    if (bombCount == 0) {
      for (int r = row - 1; r <= row + 1; r++) {
        for (int c = col - 1; c <= col + 1; c++) {
          if (isValidCell(r, c) && board[r][c] == '-' && !gameIsOver) {
            revealCell(
                r, c); // Llamada recursiva para casillas adyacentes vacías
          }
        }
      }
    }
  }

  // Función para contar las bombas en casillas adyacentes
  int countAdjacentBombs(int row, int col) {
    int bombCount = 0;
    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (isValidCell(r, c) && (board[r][c] == 'b' || board[r][c] == 'bf')) {
          bombCount++;
        }
      }
    }
    return bombCount;
  }

  // Función para verificar si una casilla es válida
  bool isValidCell(int row, int col) {
    return row >= 0 && row < numero && col >= 0 && col < numero;
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

    Image tmp1 = Image.asset('assets/images/1.png');
    Image tmpBandera = Image.asset('assets/images/bandera.jpg');
    Image tmpBomba = Image.asset('assets/images/bomba.png');
    Image tmp2 = Image.asset('assets/images/2.png');
    Image tmp3 = Image.asset('assets/images/3.png');
    Image tmp4 = Image.asset('assets/images/4.png');
    Image tmpCuadrado = Image.asset('assets/images/cuadrado.png');

    // Carrega les imatges
    if (context.mounted) {
      image1 = await convertWidgetToUiImage(tmp1);
    }
    if (context.mounted) {
      imageBandera = await convertWidgetToUiImage(tmpBandera);
    }
    if (context.mounted) {
      bomba = await convertWidgetToUiImage(tmpBomba);
    }
    if (context.mounted) {
      image2 = await convertWidgetToUiImage(tmp2);
    }
    if (context.mounted) {
      image3 = await convertWidgetToUiImage(tmp3);
    }
    if (context.mounted) {
      imageCuadrado = await convertWidgetToUiImage(tmpCuadrado);
    }
    if (context.mounted) {
      image4 = await convertWidgetToUiImage(tmp4);
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

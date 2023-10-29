import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // per a 'CustomPainter'
import 'app_data.dart';

// S'encarrega del dibuix personalitzat del joc
class WidgetTresRatllaPainter extends CustomPainter {
  final AppData appData;
  int colu;
  WidgetTresRatllaPainter(this.appData, this.colu);

  // Dibuixa les linies del taulell
  void drawBoardLines(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5.0;

    // Definim els punts on es creuaran les línies verticals
    final double firstVertical = size.width / colu;
    for (int i = 1; i < colu; i++) {
      canvas.drawLine(Offset(firstVertical * i, 0),
          Offset(firstVertical * i, size.height), paint);
    }

    // Definim els punts on es creuaran les línies horitzontals
    final double firstHorizontal = size.height / colu;

    for (int i = 1; i < colu; i++) {
      canvas.drawLine(Offset(0, firstHorizontal * i),
          Offset(size.width, firstHorizontal * i), paint);
    }
    // Dibuixem les línies horitzontals
  }

  // Dibuixa la imatge centrada a una casella del taulell
  void drawImage(Canvas canvas, ui.Image image, double x0, double y0, double x1,
      double y1) {
    double dstWidth = x1 - x0;
    double dstHeight = y1 - y0;

    double imageAspectRatio = image.width / image.height;
    double dstAspectRatio = dstWidth / dstHeight;

    double finalWidth;
    double finalHeight;

    if (imageAspectRatio > dstAspectRatio) {
      finalWidth = dstWidth;
      finalHeight = dstWidth / imageAspectRatio;
    } else {
      finalHeight = dstHeight;
      finalWidth = dstHeight * imageAspectRatio;
    }

    double offsetX = x0 + (dstWidth - finalWidth) / 2;
    double offsetY = y0 + (dstHeight - finalHeight) / 2;

    final srcRect =
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble());
    final dstRect = Rect.fromLTWH(offsetX, offsetY, finalWidth, finalHeight);

    canvas.drawImageRect(image, srcRect, dstRect, Paint());
  }

  // Dibuia una creu centrada a una casella del taulell
  void drawCross(Canvas canvas, double x0, double y0, double x1, double y1,
      Color color, double strokeWidth) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;

    canvas.drawLine(
      Offset(x0, y0),
      Offset(x1, y1),
      paint,
    );
    canvas.drawLine(
      Offset(x1, y0),
      Offset(x0, y1),
      paint,
    );
  }

  // Dibuixa el taulell de joc (creus i rodones)
  void drawBoardStatus(Canvas canvas, Size size) {
    double cellWidth = size.width / colu;
    double cellHeight = size.height / colu;
    for (int i = 0; i < colu; i++) {
      for (int j = 0; j < colu; j++) {
        final cellValue = appData.board[i][j];
        if (cellValue == "-" || cellValue == "b") {
          double x0 = j * cellWidth - 12;
          double y0 = i * cellHeight + 0;
          double x1 = (j + 1) * cellWidth + 10;
          double y1 = (i + 1) * cellHeight + 5;

          drawImage(canvas, appData.imageCuadrado!, x0, y0, x1, y1);
        }
        if (cellValue != '-' &&
            cellValue != 'b' &&
            cellValue != 'f' &&
            cellValue != 'bf') {
          if (cellValue == "1") {
            double x0 = j * cellWidth;
            double y0 = i * cellHeight + 13;
            double x1 = (j + 1) * cellWidth;
            double y1 = (i + 1) * cellHeight - 6;

            drawImage(canvas, appData.image1!, x0, y0, x1, y1);
          }
          if (cellValue == "2") {
            double x0 = j * cellWidth;
            double y0 = i * cellHeight + 13;
            double x1 = (j + 1) * cellWidth;
            double y1 = (i + 1) * cellHeight - 6;

            drawImage(canvas, appData.image2!, x0, y0, x1, y1);
          }
          if (cellValue == "3") {
            double x0 = j * cellWidth;
            double y0 = i * cellHeight + 13;
            double x1 = (j + 1) * cellWidth;
            double y1 = (i + 1) * cellHeight - 6;

            drawImage(canvas, appData.image3!, x0, y0, x1, y1);
          }
          if (cellValue == "4") {
            double x0 = j * cellWidth;
            double y0 = i * cellHeight + 13;
            double x1 = (j + 1) * cellWidth;
            double y1 = (i + 1) * cellHeight - 6;

            drawImage(canvas, appData.image4!, x0, y0, x1, y1);
          }
        }
        if (cellValue == 'f' || cellValue == 'bf') {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.imageBandera!, x0, y0, x1, y1);
        }

        if (cellValue == "x") {
          double x0 = j * cellWidth;
          double y0 = i * cellHeight;
          double x1 = (j + 1) * cellWidth;
          double y1 = (i + 1) * cellHeight;

          drawImage(canvas, appData.bomba!, x0, y0, x1, y1);
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = appData.gameWinner;

    const textStyle = TextStyle(
      color: Colors.white, // Color del texto
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          blurRadius: 4, // Radio de difuminado de la sombra
          color: Colors.black, // Color de la sombra
          offset: Offset(2, 2), // Desplazamiento de la sombra
        ),
      ],
      backgroundColor: Colors.blue, // Color de fondo del texto
      decorationThickness: 2, // Grosor del subrayado
      fontFamily:
          'YourCustomFont', // Fuente personalizada (debes tenerla en tu proyecto)
    );

    final textPainter = TextPainter(
      text: TextSpan(text: message, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: size.width,
    );

    // Centrem el text en el canvas
    final position = Offset(
      (size.width - textPainter.width) / colu - 2,
      (size.height - textPainter.height) / colu - 2,
    );

    // Dibuixar un rectangle semi-transparent que ocupi tot l'espai del canvas
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.7) // Ajusta l'opacitat com vulguis
      ..style = PaintingStyle.fill;

    canvas.drawRect(bgRect, paint);

    // Ara, dibuixar el text
    textPainter.paint(canvas, position);
  }

  // Funció principal de dibuix
  @override
  void paint(Canvas canvas, Size size) {
    drawBoardLines(canvas, size);
    drawBoardStatus(canvas, size);
    if (appData.gameWinner != '-') {
      drawGameOver(canvas, size);
    }
  }

  // Funció que diu si cal redibuixar el widget
  // Normalment hauria de comprovar si realment cal, ara només diu 'si'
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

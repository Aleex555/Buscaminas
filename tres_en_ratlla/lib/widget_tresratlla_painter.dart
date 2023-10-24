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
        if (cellValue != '-' && cellValue != 'b' && cellValue != 'f') {
          final x0 = j * cellWidth;
          final y0 = i * cellHeight;
          final x1 = (j + 1) * cellWidth;
          final y1 = (i + 1) * cellHeight;

          // Calculamos el centro de la casilla
          final cX = (x0 + x1) / 2;
          final cY = (y0 + y1) / 2;

          final textStyle = TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          );
          final textSpan = TextSpan(
            text: cellValue,
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          )..layout();

          // Calculamos las coordenadas para centrar el texto
          final textX = cX - textPainter.width / 2;
          final textY = cY - textPainter.height / 2;

          // Centramos el cuadro del texto
          final textRect = Rect.fromPoints(
            Offset(textX, textY),
            Offset(textX + textPainter.width, textY + textPainter.height),
          );

          textPainter.paint(canvas, textRect.topLeft);
        }
        if (cellValue == 'f') {
          final x0 = j * cellWidth;
          final y0 = i * cellHeight;
          final x1 = (j + 1) * cellWidth;
          final y1 = (i + 1) * cellHeight;

          // Calculamos el centro de la casilla
          final cX = (x0 + x1) / 2;
          final cY = (y0 + y1) / 2;

          final textStyle = TextStyle(
            fontSize: 24.0,
            color: Colors.black,
          );
          final textSpan = TextSpan(
            text: "f",
            style: textStyle,
          );
          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          )..layout();

          // Calculamos las coordenadas para centrar el texto
          final textX = cX - textPainter.width / 2;
          final textY = cY - textPainter.height / 2;

          // Centramos el cuadro del texto
          final textRect = Rect.fromPoints(
            Offset(textX, textY),
            Offset(textX + textPainter.width, textY + textPainter.height),
          );

          textPainter.paint(canvas, textRect.topLeft);
        }
      }
    }
  }

  // Dibuixa el missatge de joc acabat
  void drawGameOver(Canvas canvas, Size size) {
    String message = appData.gameWinner;

    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
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

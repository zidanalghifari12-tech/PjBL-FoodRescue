import 'dart:convert';
import 'package:flutter/material.dart';

class DynamicQrCode extends StatelessWidget {
  final String data;
  final double size;
  final Color darkColor;
  final Color lightColor;

  const DynamicQrCode({
    super.key,
    required this.data,
    this.size = 200,
    this.darkColor = const Color(0xFF0F172A),
    this.lightColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: CustomPaint(
        size: Size(size, size),
        painter: _QrMatrixPainter(
          data: data,
          darkColor: darkColor,
        ),
      ),
    );
  }
}

class _QrMatrixPainter extends CustomPainter {
  final String data;
  final Color darkColor;

  _QrMatrixPainter({
    required this.data,
    required this.darkColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final matrix = _generateMatrix(data);
    final count = matrix.length;
    final cellSize = size.width / count;
    final paint = Paint()
      ..color = darkColor
      ..style = PaintingStyle.fill;

    for (int r = 0; r < count; r++) {
      for (int c = 0; c < count; c++) {
        if (matrix[r][c]) {
          final rect = Rect.fromLTWH(
            c * cellSize,
            r * cellSize,
            cellSize + 0.3, // overlap slightly to avoid hairline gaps
            cellSize + 0.3,
          );

          // Give corner finder blocks smooth slightly rounded corners
          if (_isFinderCorner(r, c, count)) {
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.3)),
              paint,
            );
          } else {
            canvas.drawRRect(
              RRect.fromRectAndRadius(rect, Radius.circular(cellSize * 0.2)),
              paint,
            );
          }
        }
      }
    }
  }

  bool _isFinderCorner(int r, int c, int count) {
    return (r < 7 && c < 7) ||
        (r < 7 && c >= count - 7) ||
        (r >= count - 7 && c < 7);
  }

  List<List<bool>> _generateMatrix(String input) {
    const dimension = 21; // QR Version 1
    final matrix = List.generate(dimension, (_) => List.filled(dimension, false));
    final reserved = List.generate(dimension, (_) => List.filled(dimension, false));

    // 1. Add Finder Patterns (7x7) at 3 corners
    _applyFinderPattern(matrix, reserved, 0, 0);
    _applyFinderPattern(matrix, reserved, 0, dimension - 7);
    _applyFinderPattern(matrix, reserved, dimension - 7, 0);

    // 2. Add Separators & Timing Patterns
    for (int i = 8; i < dimension - 8; i++) {
      matrix[6][i] = (i % 2 == 0);
      matrix[i][6] = (i % 2 == 0);
      reserved[6][i] = true;
      reserved[i][6] = true;
    }

    // Dark Module
    matrix[dimension - 8][8] = true;
    reserved[dimension - 8][8] = true;

    // 3. Encode Data Bits into remaining modules
    final bytes = utf8.encode(input);
    final bits = <bool>[];

    // Simple Alphanumeric/Byte mode header
    bits.addAll([false, true, false, false]); // Byte mode (0100)
    final len = bytes.length;
    for (int i = 7; i >= 0; i--) {
      bits.add(((len >> i) & 1) == 1);
    }
    for (final b in bytes) {
      for (int i = 7; i >= 0; i--) {
        bits.add(((b >> i) & 1) == 1);
      }
    }

    // Add pseudo-random deterministic hashing from input to fill error-correction capacity
    var hash = 0x811c9dc5;
    for (final b in bytes) {
      hash ^= b;
      hash = (hash * 0x01000193) & 0xFFFFFFFF;
    }

    int bitIndex = 0;
    for (int col = dimension - 1; col > 0; col -= 2) {
      if (col == 6) col--; // skip timing column

      for (int count = 0; count < dimension; count++) {
        final upward = ((col + 1) ~/ 2) % 2 == 1;
        final row = upward ? (dimension - 1 - count) : count;

        for (int c = 0; c < 2; c++) {
          final currCol = col - c;
          if (!reserved[row][currCol]) {
            if (bitIndex < bits.length) {
              matrix[row][currCol] = bits[bitIndex];
            } else {
              // Deterministic module fill from string hash
              final moduleHash = (hash ^ (row * 31 + currCol * 17)) & 0xFFFFFFFF;
              matrix[row][currCol] = (moduleHash % 3 == 0);
            }
            bitIndex++;
          }
        }
      }
    }

    return matrix;
  }

  void _applyFinderPattern(
    List<List<bool>> matrix,
    List<List<bool>> reserved,
    int startRow,
    int startCol,
  ) {
    for (int r = 0; r < 7; r++) {
      for (int c = 0; c < 7; c++) {
        final row = startRow + r;
        final col = startCol + c;
        reserved[row][col] = true;

        if (r == 0 || r == 6 || c == 0 || c == 6) {
          matrix[row][col] = true; // outer border
        } else if (r >= 2 && r <= 4 && c >= 2 && c <= 4) {
          matrix[row][col] = true; // inner center
        } else {
          matrix[row][col] = false; // white space
        }
      }
    }

    // Mark 1-module white separator border
    for (int r = -1; r <= 7; r++) {
      for (int c = -1; c <= 7; c++) {
        final row = startRow + r;
        final col = startCol + c;
        if (row >= 0 && row < matrix.length && col >= 0 && col < matrix.length) {
          reserved[row][col] = true;
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _QrMatrixPainter oldDelegate) =>
      oldDelegate.data != data || oldDelegate.darkColor != darkColor;
}


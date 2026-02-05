import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class ConnectFourPage extends StatefulWidget {
  const ConnectFourPage({super.key});

  @override
  State<ConnectFourPage> createState() => _ConnectFourPageState();
}

class _ConnectFourPageState extends State<ConnectFourPage>
    with TickerProviderStateMixin {
  static const int rows = 6;
  static const int columns = 7;

  List<List<int>> board = List.generate(rows, (_) => List.filled(columns, 0));
  int currentPlayer = 1; // 1 for Red, 2 for Yellow
  bool isGameOver = false;
  int? winner;

  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isGameOver) {
        setState(() {
          _seconds++;
        });
      }
    });
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _dropPiece(int col) {
    if (isGameOver) return;

    for (int r = rows - 1; r >= 0; r--) {
      if (board[r][col] == 0) {
        setState(() {
          board[r][col] = currentPlayer;
          if (_checkWinner(r, col)) {
            isGameOver = true;
            winner = currentPlayer;
          } else if (_isBoardFull()) {
            isGameOver = true;
            winner = 0; // Draw
          } else {
            currentPlayer = currentPlayer == 1 ? 2 : 1;
          }
        });
        break;
      }
    }
  }

  bool _isBoardFull() {
    for (int c = 0; c < columns; c++) {
      if (board[0][c] == 0) return false;
    }
    return true;
  }

  bool _checkWinner(int r, int c) {
    int player = board[r][c];

    // Horizontal
    int count = 0;
    for (int j = 0; j < columns; j++) {
      if (board[r][j] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
    }

    // Vertical
    count = 0;
    for (int i = 0; i < rows; i++) {
      if (board[i][c] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
    }

    // Diagonal \
    count = 0;
    int dr = r - (r < c ? r : c);
    int dc = c - (r < c ? r : c);
    while (dr < rows && dc < columns) {
      if (board[dr][dc] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
      dr++;
      dc++;
    }

    // Diagonal /
    count = 0;
    dr = r + (r + c >= rows ? rows - 1 - r : c);
    dc = c - (r + c >= rows ? rows - 1 - r : c);
    while (dr >= 0 && dc < columns) {
      if (board[dr][dc] == player) {
        count++;
        if (count >= 4) return true;
      } else {
        count = 0;
      }
      dr--;
      dc++;
    }

    return false;
  }

  void _resetGame() {
    setState(() {
      board = List.generate(rows, (_) => List.filled(columns, 0));
      currentPlayer = 1;
      isGameOver = false;
      winner = null;
      _seconds = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF111827),
                    const Color(0xFF1A103C),
                    const Color(0xFF111827)
                  ]
                : [
                    const Color(0xFFE0E7FF),
                    const Color(0xFFF5F3FF),
                    const Color(0xFFFCE7F3)
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, isDark),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      _buildStatusCard(isDark),
                      const SizedBox(height: 16),
                      _buildInfoBanner(isDark),
                      const SizedBox(height: 24),
                      _buildGameBoard(isDark),
                      const SizedBox(height: 32),
                      _buildActionButtons(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_forward,
                color: isDark ? Colors.white : Colors.black87),
          ),
          Column(
            children: [
              Text(
                'چهار در یک ردیف',
                style: GoogleFonts.vazirmatn(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                'Tabdila Games',
                style: GoogleFonts.vazirmatn(
                  fontSize: 12,
                  color: const Color(0xFF8B5CF6),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: isDark ? Colors.white : Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937).withOpacity(0.7) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: currentPlayer == 1 ? Colors.red : Colors.amber,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (currentPlayer == 1 ? Colors.red : Colors.amber)
                          .withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'نوبت بازیکن: ',
                style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                currentPlayer == 1 ? 'قرمز' : 'زرد',
                style: GoogleFonts.vazirmatn(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: currentPlayer == 1 ? Colors.red : Colors.amber,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              _formatTime(_seconds),
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.blue.withOpacity(0.1) : Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'اولین کسی باشید که ۴ مهره همرنگ را در یک ردیف (افقی، عمودی یا مورب) قرار میدهد.',
              style: GoogleFonts.vazirmatn(
                fontSize: 12,
                color: isDark ? Colors.blue[100] : Colors.blue[900],
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameBoard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3730A3) : const Color(0xFF2563EB),
        borderRadius: BorderRadius.circular(24),
        border: Border(
          bottom: BorderSide(
              color: isDark ? const Color(0xFF312E81) : const Color(0xFF1E40AF),
              width: 8),
          right: BorderSide(
              color: isDark ? const Color(0xFF312E81) : const Color(0xFF1E40AF),
              width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (r) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(columns, (c) {
              return GestureDetector(
                onTap: () => _dropPiece(c),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF312E81).withOpacity(0.5)
                        : const Color(0xFF1E40AF).withOpacity(0.5),
                    shape: BoxShape.circle,
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        offset: Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: board[r][c] == 0 ? null : _buildPiece(board[r][c]),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildPiece(int player) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: player == 1
              ? [const Color(0xFFEF4444), const Color(0xFF991B1B)]
              : [const Color(0xFFFBBF24), const Color(0xFFB45309)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              // Toggle game mode or something
            },
            icon: const Icon(Icons.settings_outlined),
            label: const Text('تغییر حالت'),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              foregroundColor: const Color(0xFF8B5CF6),
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFF8B5CF6)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            label: const Text('شروع مجدد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B5CF6),
              foregroundColor: Colors.white,
              elevation: 8,
              shadowColor: const Color(0xFF8B5CF6).withOpacity(0.4),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OthelloPage extends StatefulWidget {
  const OthelloPage({super.key});

  @override
  State<OthelloPage> createState() => _OthelloPageState();
}

class _OthelloPageState extends State<OthelloPage> {
  static const int size = 8;
  late List<List<int>> _board; // 0: empty, 1: black, 2: white
  int _currentPlayer = 1;
  int _blackScore = 0;
  int _whiteScore = 0;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _resetGame();
  }

  void _resetGame() {
    setState(() {
      _board = List.generate(size, (_) => List.generate(size, (_) => 0));
      _board[3][3] = 2; // White
      _board[3][4] = 1; // Black
      _board[4][3] = 1; // Black
      _board[4][4] = 2; // White
      _currentPlayer = 1;
      _isGameOver = false;
      _updateScore();
    });
  }

  void _updateScore() {
    int b = 0;
    int w = 0;
    for (var row in _board) {
      for (var cell in row) {
        if (cell == 1) b++;
        if (cell == 2) w++;
      }
    }
    _blackScore = b;
    _whiteScore = w;
  }

  bool _isValidMove(int row, int col, int player) {
    if (_board[row][col] != 0) return false;

    int opponent = (player == 1) ? 2 : 1;
    bool valid = false;

    // Check 8 directions
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;

        int r = row + dr;
        int c = col + dc;
        bool foundOpponent = false;

        while (r >= 0 &&
            r < size &&
            c >= 0 &&
            c < size &&
            _board[r][c] == opponent) {
          r += dr;
          c += dc;
          foundOpponent = true;
        }

        if (foundOpponent &&
            r >= 0 &&
            r < size &&
            c >= 0 &&
            c < size &&
            _board[r][c] == player) {
          valid = true;
        }
      }
    }
    return valid;
  }

  void _makeMove(int row, int col) {
    if (!_isValidMove(row, col, _currentPlayer) || _isGameOver) return;

    setState(() {
      _board[row][col] = _currentPlayer;
      int opponent = (_currentPlayer == 1) ? 2 : 1;

      // Flip pieces in all directions
      for (int dr = -1; dr <= 1; dr++) {
        for (int dc = -1; dc <= 1; dc++) {
          if (dr == 0 && dc == 0) continue;

          int r = row + dr;
          int c = col + dc;
          List<Offset> toFlip = [];

          while (r >= 0 &&
              r < size &&
              c >= 0 &&
              c < size &&
              _board[r][c] == opponent) {
            toFlip.add(Offset(r.toDouble(), c.toDouble()));
            r += dr;
            c += dc;
          }

          if (toFlip.isNotEmpty &&
              r >= 0 &&
              r < size &&
              c >= 0 &&
              c < size &&
              _board[r][c] == _currentPlayer) {
            for (var pos in toFlip) {
              _board[pos.dx.toInt()][pos.dy.toInt()] = _currentPlayer;
            }
          }
        }
      }

      _currentPlayer = opponent;
      _updateScore();

      // Check if current player has moves, if not switch back
      if (!_hasValidMove(_currentPlayer)) {
        _currentPlayer = (_currentPlayer == 1) ? 2 : 1;
        if (!_hasValidMove(_currentPlayer)) {
          _isGameOver = true;
        }
      }
    });
  }

  bool _hasValidMove(int player) {
    for (int r = 0; r < size; r++) {
      for (int c = 0; c < size; c++) {
        if (_isValidMove(r, c, player)) return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = const Color(0xFF10B981);
    final boardGreen =
        isDark ? const Color(0xFF1B4332) : const Color(0xFF2D6A4F);
    final background =
        isDark ? const Color(0xFF081C15) : const Color(0xFFF3F4F6);
    final surface =
        isDark ? const Color(0xFF1B4332).withOpacity(0.3) : Colors.white;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark, primary),
            _buildScoreBoard(isDark, surface, primary),
            _buildInfoBanner(isDark),
            const Spacer(),
            _buildBoard(boardGreen),
            const Spacer(),
            _buildControls(primary),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark, Color primary) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: isDark ? Colors.white70 : Colors.black54),
          ),
          Row(
            children: [
              Text(
                'بازی اتللو',
                style: GoogleFonts.vazirmatn(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.lens, color: primary),
            ],
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildScoreBoard(bool isDark, Color surface, Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildScoreItem('سیاه', _blackScore, 1),
            _buildTurnIndicator(),
            _buildScoreItem('سفید', _whiteScore, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreItem(String label, int score, int player) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: player == 1 ? Colors.black : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$label: $score',
            style: GoogleFonts.vazirmatn(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTurnIndicator() {
    return Column(
      children: [
        Text('نوبت',
            style: GoogleFonts.vazirmatn(fontSize: 10, color: Colors.grey)),
        Text(
          _currentPlayer == 1 ? 'سیاه' : 'سفید',
          style: GoogleFonts.vazirmatn(
              fontWeight: FontWeight.w900, color: const Color(0xFF10B981)),
        ),
      ],
    );
  }

  Widget _buildInfoBanner(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'مهره‌های حریف را محاصره کنید تا همرنگ شما شوند.',
        textAlign: TextAlign.center,
        style: GoogleFonts.vazirmatn(
            fontSize: 12, color: isDark ? Colors.blue[100] : Colors.blue[800]),
      ),
    );
  }

  Widget _buildBoard(Color boardColor) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: boardColor.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black45, blurRadius: 15, offset: Offset(0, 8))
          ],
        ),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: size * size,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            int r = index ~/ size;
            int c = index % size;
            return _buildCell(r, c);
          },
        ),
      ),
    );
  }

  Widget _buildCell(int r, int c) {
    int value = _board[r][c];
    bool isValid = _isValidMove(r, c, _currentPlayer);

    return GestureDetector(
      onTap: () => _makeMove(r, c),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child:
              value != 0 ? _buildPiece(value) : (isValid ? _buildHint() : null),
        ),
      ),
    );
  }

  Widget _buildPiece(int player) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: player == 1 ? Colors.black : Colors.white,
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: player == 1
              ? [Colors.grey[800]!, Colors.black]
              : [Colors.white, Colors.grey[300]!],
          center: const Alignment(-0.3, -0.3),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 4,
              offset: Offset(2, 2)),
        ],
      ),
    );
  }

  Widget _buildHint() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildControls(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _resetGame,
              icon: const Icon(Icons.refresh),
              label: const Text('بازی جدید'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 56),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

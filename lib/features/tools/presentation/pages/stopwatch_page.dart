import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Lap {
  final int index;
  final Duration lapTime;
  final Duration totalTime;

  Lap({required this.index, required this.lapTime, required this.totalTime});
}

class StopwatchPage extends StatefulWidget {
  const StopwatchPage({super.key});

  @override
  State<StopwatchPage> createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  List<Lap> _laps = [];
  Duration _lastLapTotalTime = Duration.zero;

  void _startStopwatch() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
    } else {
      _stopwatch.start();
      _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
        setState(() {});
      });
    }
  }

  void _resetStopwatch() {
    setState(() {
      _stopwatch.stop();
      _stopwatch.reset();
      _timer?.cancel();
      _laps.clear();
      _lastLapTotalTime = Duration.zero;
    });
  }

  void _addLap() {
    if (!_stopwatch.isRunning) return;

    final currentTotal = _stopwatch.elapsed;
    final lapTime = currentTotal - _lastLapTotalTime;

    setState(() {
      _laps.insert(
          0,
          Lap(
            index: _laps.length + 1,
            lapTime: lapTime,
            totalTime: currentTotal,
          ));
      _lastLapTotalTime = currentTotal;
    });
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    String seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatMilliseconds(Duration d) {
    return (d.inMilliseconds.remainder(1000) ~/ 10).toString().padLeft(2, '0');
  }

  Lap? _getFastestLap() {
    if (_laps.isEmpty) return null;
    Lap fastest = _laps[0];
    for (var lap in _laps) {
      if (lap.lapTime < fastest.lapTime) {
        fastest = lap;
      }
    }
    return fastest;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? const Color(0xFF0F0817) : const Color(0xFFF7F6F8);
    final primaryColor = const Color(0xFF7F13EC);
    final accentCyan = const Color(0xFF00F0FF);
    final accentGreen = const Color(0xFF00FF9D);

    final fastestLap = _getFastestLap();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Cyber Grid Background
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: GridPainter(color: primaryColor),
              ),
            ),
          ),

          // Glow effects
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon:
                            const Icon(Icons.arrow_back, color: Colors.white70),
                      ),
                      Text(
                        'کرنومتر پرو',
                        style: GoogleFonts.vazirmatn(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.settings, color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                // Timer Circle
                Expanded(
                  flex: 3,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Glow Ring
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: primaryColor.withOpacity(0.2), width: 1),
                            boxShadow: [
                              BoxShadow(
                                  color: primaryColor.withOpacity(0.3),
                                  blurRadius: 40,
                                  spreadRadius: -10),
                            ],
                          ),
                        ),
                        // Progress Ring (Static or animated based on seconds)
                        SizedBox(
                          width: 250,
                          height: 250,
                          child: CircularProgressIndicator(
                            value: (_stopwatch.elapsed.inMilliseconds % 60000) /
                                60000,
                            strokeWidth: 4,
                            backgroundColor: Colors.white.withOpacity(0.05),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentCyan),
                          ),
                        ),
                        // Inner content
                        Container(
                          width: 230,
                          height: 230,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isDark ? const Color(0xFF0F0817) : Colors.white,
                            border: Border.all(
                                color: Colors.white.withOpacity(0.05)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _formatDuration(_stopwatch.elapsed),
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 54,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    '.${_formatMilliseconds(_stopwatch.elapsed)}',
                                    style: GoogleFonts.spaceGrotesk(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (_stopwatch.isRunning)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: primaryColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    'در حال اجرا',
                                    style: GoogleFonts.vazirmatn(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Laps List
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('زمان کل',
                                style: GoogleFonts.vazirmatn(
                                    fontSize: 12,
                                    color: accentCyan,
                                    fontWeight: FontWeight.bold)),
                            Text('زمان دور',
                                style: GoogleFonts.vazirmatn(
                                    fontSize: 12,
                                    color: accentCyan,
                                    fontWeight: FontWeight.bold)),
                            Text('شماره دور',
                                style: GoogleFonts.vazirmatn(
                                    fontSize: 12,
                                    color: accentCyan,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _laps.length,
                          itemBuilder: (context, index) {
                            final lap = _laps[index];
                            final isFastest = lap == fastestLap;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border(
                                    right: BorderSide(
                                      color: isFastest
                                          ? accentGreen
                                          : Colors.transparent,
                                      width: 4,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_formatDuration(lap.totalTime)}.${_formatMilliseconds(lap.totalTime)}',
                                      style: GoogleFonts.spaceGrotesk(
                                          fontSize: 14, color: Colors.white54),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${_formatDuration(lap.lapTime)}.${_formatMilliseconds(lap.lapTime)}',
                                          style: GoogleFonts.spaceGrotesk(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                        if (isFastest)
                                          Text('سریع‌ترین',
                                              style: GoogleFonts.vazirmatn(
                                                  fontSize: 10,
                                                  color: accentGreen,
                                                  fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: isFastest
                                            ? accentGreen.withOpacity(0.2)
                                            : Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          lap.index.toString().padLeft(2, '۰'),
                                          style: GoogleFonts.vazirmatn(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: isFastest
                                                ? accentGreen
                                                : Colors.white70,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Controls
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  child: Row(
                    children: [
                      // Reset / Lap Button
                      Expanded(
                        child: GestureDetector(
                          onTap:
                              _stopwatch.isRunning ? _addLap : _resetStopwatch,
                          child: Container(
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: accentCyan.withOpacity(0.3), width: 2),
                              color: accentCyan.withOpacity(0.05),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    _stopwatch.isRunning
                                        ? Icons.flag
                                        : Icons.replay,
                                    color: accentCyan),
                                const SizedBox(width: 8),
                                Text(
                                  _stopwatch.isRunning
                                      ? 'دور جدید'
                                      : 'تنظیم مجدد',
                                  style: GoogleFonts.vazirmatn(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: accentCyan),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Start / Stop Button
                      Expanded(
                        child: GestureDetector(
                          onTap: _startStopwatch,
                          child: Container(
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  primaryColor,
                                  primaryColor.withOpacity(0.8)
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: primaryColor.withOpacity(0.4),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5)),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                    _stopwatch.isRunning
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  _stopwatch.isRunning ? 'توقف' : 'شروع',
                                  style: GoogleFonts.vazirmatn(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.2)
      ..strokeWidth = 1;

    for (double i = 0; i <= size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i <= size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

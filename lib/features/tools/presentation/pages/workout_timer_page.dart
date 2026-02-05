import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/utils/digit_utils.dart';

enum TimerPhase { workout, rest, ready }

class WorkoutTimerPage extends StatefulWidget {
  const WorkoutTimerPage({super.key});

  @override
  State<WorkoutTimerPage> createState() => _WorkoutTimerPageState();
}

class _WorkoutTimerPageState extends State<WorkoutTimerPage>
    with TickerProviderStateMixin {
  int _workoutTime = 45;
  int _restTime = 15;
  int _totalRounds = 8;

  int _currentRound = 1;
  int _secondsRemaining = 45;
  bool _isRunning = false;
  TimerPhase _phase = TimerPhase.workout;

  Timer? _timer;

  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: Duration(seconds: _workoutTime),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _progressController.dispose();
    super.dispose();
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
      _progressController.stop();
    } else {
      _startTimer();
    }
    setState(() => _isRunning = !_isRunning);
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _nextPhase();
      }
    });
    _progressController.duration = Duration(seconds: _secondsRemaining);
    _progressController.reverse(
        from: _secondsRemaining /
            (_phase == TimerPhase.workout ? _workoutTime : _restTime));
  }

  void _nextPhase() {
    _timer?.cancel();
    if (_phase == TimerPhase.workout) {
      if (_currentRound >= _totalRounds) {
        _resetTimer();
        _showFinishedDialog();
        return;
      }
      setState(() {
        _phase = TimerPhase.rest;
        _secondsRemaining = _restTime;
      });
    } else {
      setState(() {
        _phase = TimerPhase.workout;
        _secondsRemaining = _workoutTime;
        _currentRound++;
      });
    }
    _startTimer();
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _currentRound = 1;
      _secondsRemaining = _workoutTime;
      _phase = TimerPhase.workout;
    });
    _progressController.reset();
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A1E35),
        title: Text('خسته نباشید!',
            style: GoogleFonts.vazirmatn(color: Colors.white)),
        content: Text('تمرین شما با موفقیت به پایان رسید.',
            style: GoogleFonts.vazirmatn(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('تایید',
                style: GoogleFonts.vazirmatn(color: const Color(0xFF7F13EC))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF7F13EC);
    const backgroundDark = Color(0xFF191022);
    const surfaceDark = Color(0xFF2A1E35);

    return Scaffold(
      backgroundColor: backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildStatusBadge(primaryColor, surfaceDark),
                    const SizedBox(height: 20),
                    _buildCircularTimer(primaryColor, surfaceDark),
                    const SizedBox(height: 32),
                    _buildStats(surfaceDark),
                    const SizedBox(height: 32),
                    _buildAdjuster(
                        'زمان تمرین', Icons.fitness_center, _workoutTime,
                        (val) {
                      setState(() {
                        _workoutTime = val;
                        if (!_isRunning && _phase == TimerPhase.workout)
                          _secondsRemaining = val;
                      });
                    }, primaryColor.withOpacity(0.2), primaryColor),
                    _buildAdjuster('زمان استراحت', Icons.chair, _restTime,
                        (val) {
                      setState(() {
                        _restTime = val;
                        if (!_isRunning && _phase == TimerPhase.rest)
                          _secondsRemaining = val;
                      });
                    }, Colors.blue.withOpacity(0.2), Colors.blueAccent),
                    _buildAdjuster('تعداد دور', Icons.refresh, _totalRounds,
                        (val) {
                      setState(() => _totalRounds = val);
                    }, Colors.orange.withOpacity(0.2), Colors.orangeAccent),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildControls(primaryColor, surfaceDark),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward, color: Colors.white70),
          ),
          Text(
            'زمانسنج حرفه‌ای',
            style: GoogleFonts.vazirmatn(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(Color primary, Color surface) {
    String text = _phase == TimerPhase.workout ? 'تمرین' : 'استراحت';
    Color color = _phase == TimerPhase.workout ? primary : Colors.blueAccent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.5), blurRadius: 8)
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(text,
              style: GoogleFonts.vazirmatn(
                  fontSize: 12, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildCircularTimer(Color primary, Color surface) {
    double total = _phase == TimerPhase.workout
        ? _workoutTime.toDouble()
        : _restTime.toDouble();
    double progress = _secondsRemaining / total;
    Color color = _phase == TimerPhase.workout ? primary : Colors.blueAccent;

    return Container(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Glow
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.05),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.1), blurRadius: 40)
              ],
            ),
          ),
          // Ring
          SizedBox(
            width: 260,
            height: 260,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 12,
              backgroundColor: surface,
              color: color,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DigitUtils.toFarsi(
                    "${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}"),
                style: GoogleFonts.lexend(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                DigitUtils.toFarsi(
                    "مجموع: ${(_totalRounds * (_workoutTime + _restTime) ~/ 60).toString().padLeft(2, '0')}:${(_totalRounds * (_workoutTime + _restTime) % 60).toString().padLeft(2, '0')}"),
                style:
                    GoogleFonts.vazirmatn(fontSize: 14, color: Colors.white38),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats(Color surface) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatItem('دور فعلی',
            "${DigitUtils.toFarsi(_currentRound.toString())} / ${DigitUtils.toFarsi(_totalRounds.toString())}"),
        Container(
            width: 1,
            height: 30,
            color: Colors.white10,
            margin: const EdgeInsets.symmetric(horizontal: 40)),
        _buildStatItem(
            'کالری', DigitUtils.toFarsi((_currentRound * 15).toString())),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.vazirmatn(fontSize: 12, color: Colors.white38)),
        const SizedBox(height: 4),
        Text(value,
            style: GoogleFonts.lexend(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ],
    );
  }

  Widget _buildAdjuster(String label, IconData icon, int value,
      ValueChanged<int> onChanged, Color iconBg, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1E35).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: iconBg, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Text(label,
                  style: GoogleFonts.vazirmatn(
                      fontSize: 14, color: Colors.white70)),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: const Color(0xFF191022).withOpacity(0.8),
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                _buildAdjustBtn(
                    Icons.remove, () => onChanged(math.max(1, value - 1))),
                const SizedBox(width: 16),
                Text(DigitUtils.toFarsi(value.toString()),
                    style: GoogleFonts.lexend(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(width: 16),
                _buildAdjustBtn(Icons.add, () => onChanged(value + 1)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: const Color(0xFF362348),
            borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _buildControls(Color primary, Color surface) {
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildControlBtn(Icons.replay, _resetTimer, surface),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: _toggleTimer,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: primary.withOpacity(0.4), blurRadius: 20)
                ],
              ),
              child: Icon(_isRunning ? Icons.pause : Icons.play_arrow,
                  color: Colors.white, size: 40),
            ),
          ),
          const SizedBox(width: 24),
          _buildControlBtn(Icons.volume_up, () {}, surface),
        ],
      ),
    );
  }

  Widget _buildControlBtn(IconData icon, VoidCallback onTap, Color bgColor) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF362348),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import '../../../../core/utils/digit_utils.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  int _hours = 0;
  int _minutes = 15;
  int _seconds = 0;
  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isRunning = false;

  final FixedExtentScrollController _hourController =
      FixedExtentScrollController(initialItem: 0);
  final FixedExtentScrollController _minController =
      FixedExtentScrollController(initialItem: 15);
  final FixedExtentScrollController _secController =
      FixedExtentScrollController(initialItem: 0);

  void _startTimer() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      return;
    }

    if (_remainingSeconds == 0) {
      _remainingSeconds = (_hours * 3600) + (_minutes * 60) + _seconds;
    }

    if (_remainingSeconds <= 0) return;

    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        setState(() => _isRunning = false);
        _showFinishedDialog();
      }
    });
  }

  void _showFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('پایان زمان', style: GoogleFonts.vazirmatn()),
        content: Text('زمان تعیین شده به پایان رسید.',
            style: GoogleFonts.vazirmatn()),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('متوجه شدم', style: GoogleFonts.vazirmatn())),
        ],
      ),
    );
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _isRunning = false;
    });
  }

  void _setPreset(int mins) {
    setState(() {
      _hours = 0;
      _minutes = mins;
      _seconds = 0;
      _remainingSeconds = mins * 60;
      _hourController.jumpToItem(0);
      _minController.jumpToItem(mins);
      _secController.jumpToItem(0);
    });
  }

  String _formatTime(int totalSeconds) {
    int h = totalSeconds ~/ 3600;
    int m = (totalSeconds % 3600) ~/ 60;
    int s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF7F13EC);
    const primaryLight = Color(0xFF9F4AFF);

    return Scaffold(
      backgroundColor: const Color(0xFF191022),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: primary.withOpacity(0.15)),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Colors.blue.withOpacity(0.05)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDisplayArea(),
                      const SizedBox(height: 40),
                      if (!_isRunning && _remainingSeconds == 0)
                        _buildPickers(),
                    ],
                  ),
                ),
                _buildControls(primary, primaryLight),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_forward, color: Colors.white70),
          ),
          Text('تایمر',
              style: GoogleFonts.vazirmatn(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.music_note, color: Colors.white70)),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.settings, color: Colors.white70)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayArea() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.white.withOpacity(0.05), width: 1),
              ),
            ),
            Text(
              DigitUtils.toFarsi(_formatTime(_isRunning || _remainingSeconds > 0
                  ? _remainingSeconds
                  : (_hours * 3600 + _minutes * 60 + _seconds))),
              style: GoogleFonts.manrope(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text('زمان باقیمانده',
            style: GoogleFonts.vazirmatn(fontSize: 14, color: Colors.white38)),
      ],
    );
  }

  Widget _buildPickers() {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF7F13EC).withOpacity(0.1),
              border: Border.symmetric(
                  vertical: BorderSide.none,
                  horizontal: BorderSide(
                      color: const Color(0xFF7F13EC).withOpacity(0.3))),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPickerColumn(_hourController, 24,
                  (val) => setState(() => _hours = val), 'ساعت'),
              const Text(':',
                  style: TextStyle(
                      color: Colors.white30,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              _buildPickerColumn(_minController, 60,
                  (val) => setState(() => _minutes = val), 'دقیقه'),
              const Text(':',
                  style: TextStyle(
                      color: Colors.white30,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              _buildPickerColumn(_secController, 60,
                  (val) => setState(() => _seconds = val), 'ثانیه'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn(FixedExtentScrollController controller, int count,
      ValueChanged<int> onSelected, String label) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Expanded(
            child: ListWheelScrollView.useDelegate(
              controller: controller,
              itemExtent: 50,
              physics: const FixedExtentScrollPhysics(),
              onSelectedItemChanged: onSelected,
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: count,
                builder: (context, index) => Center(
                  child: Text(
                    DigitUtils.toFarsi(index.toString().padLeft(2, '0')),
                    style: GoogleFonts.manrope(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(label,
                style:
                    GoogleFonts.vazirmatn(fontSize: 10, color: Colors.white30)),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(Color primary, Color primaryLight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          if (!_isRunning && _remainingSeconds == 0)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPresetButton('۵ دقیقه', 5),
                  _buildPresetButton('۱۰ دقیقه', 10),
                  _buildPresetButton('۱۵ دقیقه', 15),
                  _buildPresetButton('۳۰ دقیقه', 30),
                  _buildPresetButton('۱ ساعت', 60),
                ],
              ),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_remainingSeconds > 0) ...[
                IconButton(
                  onPressed: _resetTimer,
                  icon: const Icon(Icons.refresh,
                      color: Colors.white70, size: 32),
                ),
                const SizedBox(width: 40),
              ],
              GestureDetector(
                onTap: _startTimer,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [primary, primaryLight]),
                    boxShadow: [
                      BoxShadow(
                          color: primary.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2),
                    ],
                  ),
                  child: Icon(_isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white, size: 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButton(String label, int mins) {
    bool isSelected = _minutes == mins && _hours == 0 && _seconds == 0;
    return GestureDetector(
      onTap: () => _setPreset(mins),
      child: Container(
        margin: const EdgeInsets.only(left: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF7F13EC).withOpacity(0.2)
              : const Color(0xFF2D1B3E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? const Color(0xFF7F13EC) : Colors.white10),
        ),
        child: Text(DigitUtils.toFarsi(label),
            style: GoogleFonts.vazirmatn(
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.white70)),
      ),
    );
  }
}

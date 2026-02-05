import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import '../../../../core/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  int _variantIndex = 0;
  double _progress = 0.0;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _variantIndex = Random().nextInt(5); // 0-4 (including original + 4 new)

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {
          _progress = _progressController.value;
        });
      });

    _progressController.forward();
    _startNavigationTimer();
  }

  void _startNavigationTimer() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    Future.delayed(const Duration(seconds: 3, milliseconds: 500), () {
      if (mounted) {
        if (hasSeenOnboarding) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        } else {
          Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
        }
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    switch (_variantIndex) {
      case 1:
        return _FuturisticSplash(progress: _progress);
      case 2:
        return _ElegantSplash(progress: _progress);
      case 3:
        return _GradientSplash(progress: _progress);
      case 4:
        return _OrbitSplash(progress: _progress);
      default:
        return _OriginalSplash(progress: _progress);
    }
  }
}

// Variant 1: Futuristic Loading
class _FuturisticSplash extends StatefulWidget {
  final double progress;
  const _FuturisticSplash({required this.progress});

  @override
  State<_FuturisticSplash> createState() => _FuturisticSplashState();
}

class _FuturisticSplashState extends State<_FuturisticSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(191022 + 0xFF000000), // #191022
      body: Stack(
        children: [
          // Cosmic Dust/Orbs background
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7F13EC).withOpacity(0.15),
              ),
              child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                  child: Container()),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    RotationTransition(
                      turns: _rotationController,
                      child: Container(
                        width: 256,
                        height: 256,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: SweepGradient(
                            colors: [
                              Colors.transparent,
                              const Color(0xFF7F13EC).withOpacity(0.2),
                              const Color(0xFF7F13EC),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D1B3E),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF7F13EC).withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7F13EC).withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAjjuv-TmyuQLKfQTHDDyyzlH6jcfFm3ZwwcsijvGNiwDBD19O_3gHT3u6fb-_TyOxlkyRVxq0bKL7PbGRqgLVBxDoFgRW4EDe_otwiamQq-JhLvgGdMYRKJ81YbyXLZiFTYKtqJ8ekOJq7RAC6sC6maik1-oD2Ma0-s2C8g040cbEpAZQG9-9bCR2oqrGKUkrNSriRYjNUnbhdWeZJTRUySDNnjcT5OvHGmSGjs72RzimSKJC_yGDCKTgZzzqWPMjqRrEnb6vpqws'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 60),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('STATUS',
                              style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  color: const Color(0xFF9F54FC),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Initializing Tools...',
                              style: GoogleFonts.manrope(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Text('${(widget.progress * 100).toInt()}%',
                          style: GoogleFonts.manrope(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: widget.progress,
                      minHeight: 8,
                      backgroundColor: const Color(0xFF2D1B3E),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF7F13EC)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cached,
                        size: 14, color: Color(0xFF9F54FC)),
                    const SizedBox(width: 8),
                    Text('در حال بارگذاری اجزا...',
                        style: GoogleFonts.vazirmatn(
                            fontSize: 12, color: const Color(0xFFAD92C9))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Variant 2: Elegant Loading
class _ElegantSplash extends StatelessWidget {
  final double progress;
  const _ElegantSplash({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              Color(0xFF4A1D6E),
              Color(0xFF191022),
              Color(0xFF120B18),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                    child: const Center(
                      child:
                          Icon(Icons.swap_horiz, size: 80, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Tabdila',
                  style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const Spacer(),
              Text('Wait a moment...',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: Colors.white.withOpacity(0.8))),
              Text('کمی منتظر بمانید',
                  style: GoogleFonts.vazirmatn(
                      fontSize: 12, color: Colors.white.withOpacity(0.6))),
              const SizedBox(height: 16),
              SizedBox(
                width: 280,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white10,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Color(0xFF7F13EC)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('v1.0',
                  style: GoogleFonts.spaceMono(
                      fontSize: 10, color: Colors.white24)),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

// Variant 3: Splash Screen
class _GradientSplash extends StatelessWidget {
  final double progress;
  const _GradientSplash({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0C),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: const Color(0xFF7F13EC).withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 10),
                        ],
                      ),
                    ),
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2A1B3D), Color(0xFF1A1122)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                            color: const Color(0xFF7F13EC).withOpacity(0.3)),
                      ),
                      child: const Center(
                        child: Icon(Icons.swap_horiz,
                            size: 64, color: Color(0xFF7F13EC)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text('تبدیلا',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Colors.white)),
                Text('TABDILA',
                    style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF7F13EC),
                        letterSpacing: 4)),
                const SizedBox(height: 12),
                Text('ابزار هوشمند تبدیل و محاسبه',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 14, color: Colors.grey[400])),
                const SizedBox(height: 60),
                SizedBox(
                  width: 280,
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF7F13EC)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('در حال بارگذاری هوشمند...',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text('طراحی شده توسط حسین طاهری',
                    style: GoogleFonts.vazirmatn(
                        fontSize: 11, color: const Color(0xFFAD92C9))),
                Text('VERSION 1.0',
                    style: GoogleFonts.manrope(
                        fontSize: 10, color: Colors.grey[700])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Variant 4: Orbit System
class _OrbitSplash extends StatefulWidget {
  final double progress;
  const _OrbitSplash({required this.progress});

  @override
  State<_OrbitSplash> createState() => _OrbitSplashState();
}

class _OrbitSplashState extends State<_OrbitSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF191022),
      body: Center(
        child: Column(
          children: [
            const Spacer(),
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Rings
                  Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF7F13EC).withOpacity(0.1))),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFF7F13EC).withOpacity(0.05))),
                  ),
                  // Center Logo
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                              colors: [Color(0xFF9D4EDD), Color(0xFF7F13EC)]),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF7F13EC).withOpacity(0.5),
                                blurRadius: 30)
                          ],
                          border: Border.all(
                              color: const Color(0xFF2D1B3E), width: 4),
                        ),
                        child: const Icon(Icons.token,
                            size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      Text('Tabdila',
                          style: GoogleFonts.manrope(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                  // Satellites
                  _buildSatellite(0, Icons.psychology, 'AI TOOLS'),
                  _buildSatellite(120, Icons.account_balance_wallet, 'FINANCE'),
                  _buildSatellite(240, Icons.currency_exchange, 'CONVERT'),
                ],
              ),
            ),
            const Spacer(),
            CircularProgressIndicator(
                value: widget.progress,
                color: const Color(0xFF7F13EC),
                strokeWidth: 4),
            const SizedBox(height: 24),
            Text('Developed by Hossein Taheri',
                style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: const Color(0xFFAD92C9).withOpacity(0.8))),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSatellite(double angleDegrees, IconData icon, String label) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = (angleDegrees * pi / 180) + (_controller.value * 2 * pi);
        return Transform.translate(
          offset: Offset(140 * cos(angle), 140 * sin(angle)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1B3E),
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: const Color(0xFF7F13EC).withOpacity(0.4)),
                ),
                child: Icon(icon, size: 24, color: const Color(0xFF7F13EC)),
              ),
              const SizedBox(height: 4),
              Text(label,
                  style: GoogleFonts.manrope(
                      fontSize: 8,
                      color: Colors.white54,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        );
      },
    );
  }
}

// Current/Original Splash
class _OriginalSplash extends StatelessWidget {
  final double progress;
  const _OriginalSplash({required this.progress});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    const Color(0xFF191022),
                    const Color(0xFF191022).withOpacity(0.9)
                  ]
                : [
                    const Color(0xFFF7F6F8),
                    const Color(0xFFF7F6F8).withOpacity(0.9)
                  ],
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 40),
                  _buildAppTitle(context),
                  const SizedBox(height: 100),
                  _buildProgress(context, isDark),
                  const SizedBox(height: 20),
                  Text(
                    'دستیار هوشمند محاسبات و ابزارها',
                    style:
                        GoogleFonts.vazirmatn(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF7F13EC).withOpacity(0.4),
          ),
        ),
        Container(
          width: 128,
          height: 128,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFF7F13EC),
          ),
          child: const Icon(Icons.smart_toy, size: 64, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildAppTitle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('تبدیلا',
            style: GoogleFonts.vazirmatn(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black)),
        const SizedBox(width: 8),
        Text('|',
            style: TextStyle(
                fontSize: 24, color: const Color(0xFF7F13EC).withOpacity(0.6))),
        const SizedBox(width: 8),
        Text('Tabdila',
            style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : Colors.black)),
      ],
    );
  }

  Widget _buildProgress(BuildContext context, bool isDark) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: LinearProgressIndicator(
          value: progress,
          minHeight: 6,
          backgroundColor:
              isDark ? Colors.white10 : Colors.black.withOpacity(0.1),
          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7F13EC)),
        ),
      ),
    );
  }
}

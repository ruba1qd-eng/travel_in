import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../state/app_state.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _intro =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..forward();
  late final Animation<double> _scale =
      CurvedAnimation(parent: _intro, curve: const Interval(0, .6, curve: Curves.easeOutBack));
  late final Animation<double> _fade =
      CurvedAnimation(parent: _intro, curve: const Interval(.2, .8));

  late final AnimationController _car =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
        ..repeat(reverse: true);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), _go);
  }

  void _go() {
    if (!mounted) return;
    final user = context.read<AppState>().user;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => user == null ? const LoginScreen() : const HomeScreen(),
    ));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _intro.dispose();
    _car.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B6E4F), Color(0xFF06382A)],
          ),
        ),
        child: SafeArea(
          child: Stack(children: [
            Center(
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                FadeTransition(
                  opacity: _fade,
                  child: ScaleTransition(
                    scale: _scale,
                    child: Container(
                      width: 130, height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(36),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(.35), blurRadius: 30, offset: const Offset(0, 12))
                        ],
                      ),
                      child: const Icon(Icons.flight_takeoff, size: 70, color: Color(0xFF0B6E4F)),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FadeTransition(
                  opacity: _fade,
                  child: const Text('Travel In',
                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fade,
                  child: Text(l.t('tagline'),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(.85), fontSize: 16)),
                ),
                const SizedBox(height: 36),
                ClipRect(
                  child: SizedBox(
                    width: 220, height: 44,
                    child: AnimatedBuilder(
                      animation: _car,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(-110 + 220 * _car.value, 0),
                        child: child,
                      ),
                      child: const Icon(Icons.directions_car_filled, color: Colors.white70, size: 34),
                    ),
                  ),
                ),
                Container(width: 220, height: 2, color: Colors.white24),
              ]),
            ),
            Positioned(
              bottom: 24, left: 0, right: 0,
              child: Column(children: [
                const SizedBox(
                    width: 28, height: 28,
                    child: CircularProgressIndicator(color: Colors.white70, strokeWidth: 2.5)),
                const SizedBox(height: 10),
                TextButton(onPressed: _go, child: Text(l.t('skip'), style: const TextStyle(color: Colors.white70))),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

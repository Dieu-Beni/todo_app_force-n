import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller.forward();

    // Navigation après chargement
    Future.delayed(const Duration(seconds: 10), () {
      // Navigator.pushReplacement(...)
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20,
          ),
          child: Column(
            children: [
              const Spacer(),

              // TITRE
              const Text(
                "Bienvenue sur Todo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3049C9),
                  fontFamily: 'Serif',
                ),
              ),

              const SizedBox(height: 20),

              // SOUS TITRE
              const Text(
                "Votre application de gestion de tâches",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF3049C9),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 70),

              // IMAGE
              SizedBox(
                height: 320,
                child: Image.asset(
                  "assets/images/todo_splash.png",
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 80),

              // DESCRIPTION
              const Text(
                "Gerez toutes vos tâches en un seul endroit et\nsuivez votre progression",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3049C9),
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // BARRE DE CHARGEMENT
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: _animation.value,
                        minHeight: 10,
                        backgroundColor:
                        Colors.blue.withOpacity(0.15),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          Color(0xFF3049C9),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
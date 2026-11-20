import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ForgivenessScreen extends StatefulWidget {
  const ForgivenessScreen({super.key});

  @override
  State<ForgivenessScreen> createState() => _ForgivenessScreenState();
}

class _ForgivenessScreenState extends State<ForgivenessScreen> {
  late AudioPlayer _audioPlayer;
  bool _isFlashPlayed = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _playSound();
    _startTimer();
  }

  void _playSound() async {
    try {
      await _audioPlayer.setAsset('assets/sounds/cat_meow.mp3');
      await _audioPlayer.play();
    } catch (e) {
      // Если звук не найден — просто игнорируем
    }
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pop(); // Закрываем экран и возвращаемся назад
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: AnimatedOpacity(
          opacity: _isFlashPlayed ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          onEnd: () {
            setState(() {
              _isFlashPlayed = true;
            });
          },
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.yellow.shade300,
                  Colors.yellow.shade200,
                  Colors.transparent,
                ],
                stops: const [0.0, 0.6, 0.9],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.shade300.withOpacity(0.5),
                  blurRadius: 30,
                  spreadRadius: 10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: const Text(
              'Карма оценила ваше великодушие.\nОна аплодирует стоя.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                shadows: [
                  Shadow(
                    blurRadius: 5,
                    color: Colors.black,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

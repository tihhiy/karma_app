import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forgiveness_screen.dart';

void main() {
  runApp(const KarmaApp());
}

class KarmaApp extends StatelessWidget {
  const KarmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Карма',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Nunito', // Подключаем шрифт
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isAccepted = false;
  int _karmaCount = 0;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadState();
  }

  void _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? agreed = prefs.getBool('agreedToTOS');
    final int? count = prefs.getInt('karmaCount');
    setState(() {
      _isAccepted = agreed ?? false;
      _karmaCount = count ?? 0;
    });
  }

  void _acceptTOS() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('agreedToTOS', true);
    int newCount = _karmaCount + 1;
    await prefs.setInt('karmaCount', newCount);
    setState(() {
      _isAccepted = true;
      _karmaCount = newCount;
    });
  }

  void _startRevenge() async {
    // Здесь будет логика мести (позже добавим)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Путь мести выбран. Вселенная помнит.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _startForgiveness() async {
    if (_isAccepted) return; // Если уже было решение — не открываем

    // Проигрываем звук гонга
    try {
      await _audioPlayer.setAsset('assets/sounds/gong.mp3');
      await _audioPlayer.play();
    } catch (e) {
      // Если звук не найден — просто игнорируем
    }

    // Открываем экран прощения
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ForgivenessScreen()),
    );

    // После закрытия экрана — сохраняем выбор
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('agreedToTOS', true);
    int newCount = _karmaCount + 1;
    await prefs.setInt('karmaCount', newCount);
    setState(() {
      _isAccepted = true;
      _karmaCount = newCount;

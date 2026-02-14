import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(MiniGameApp());
}

class MiniGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catch the Falling Items',
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Made by Devpriya Jain',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen()),
                );
              },
              child: Text('Start Game', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int basketWidth = 80;
  static const int basketHeight = 20;
  double basketX = 150;
  double itemX = 0;
  double itemY = 0;
  int score = 0;
  int lives = 3;
  double screenWidth = 300;
  double screenHeight = 500;

  Timer? timer;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    resetItem();
    timer = Timer.periodic(Duration(milliseconds: 50), (_) => updateGame());
  }

  void resetItem() {
    itemX = random.nextDouble() * (screenWidth - 30);
    itemY = 0;
  }

  void updateGame() {
    setState(() {
      itemY += 5;
      if (itemY + 30 >= screenHeight - basketHeight &&
          itemX + 30 >= basketX &&
          itemX <= basketX + basketWidth) {
        score += 1;
        resetItem();
      } else if (itemY > screenHeight) {
        lives -= 1;
        if (lives <= 0) {
          timer?.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => EndScreen(finalScore: score),
            ),
          );
        } else {
          resetItem();
        }
      }
    });
  }

  void moveLeft() {
    setState(() {
      basketX = max(0, basketX - 20);
    });
  }

  void moveRight() {
    setState(() {
      basketX = min(screenWidth - basketWidth, basketX + 20);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height - 100;

    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Stack(
        children: [
          Positioned(
            left: itemX,
            top: itemY,
            child: Container(
              width: 30,
              height: 30,
              decoration:
                  BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
          Positioned(
            left: basketX,
            top: screenHeight - basketHeight,
            child: Container(
              width: basketWidth.toDouble(),
              height: basketHeight.toDouble(),
              color: Colors.brown,
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Text('Score: $score  Lives: $lives',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: moveLeft,
              child: Icon(Icons.arrow_left, size: 30),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: moveRight,
              child: Icon(Icons.arrow_right, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  final int finalScore;
  EndScreen({required this.finalScore});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Game Over!',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Text('Your Score: $finalScore', style: TextStyle(fontSize: 22)),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => StartScreen()),
                );
              },
              child: Text('Restart Game', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

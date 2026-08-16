import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const SnakeLadderApp());

class SnakeLadderApp extends StatelessWidget {
  const SnakeLadderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SetupScreen(),
    );
  }
}

// Model for Player Profile
class Player {
  final String name;
  final String avatarPath;
  int position;
  String emotion; // "neutral", "happy", "sad"

  Player({
    required this.name,
    required this.avatarPath,
    this.position = 1,
    this.emotion = "neutral",
  });
}

// 1. Setup & Character Selection Screen
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int playerCount = 2;
  final List<String> availableAvatars = [
    'assets/images/bheem.png',
    'assets/images/cricketer_virat.png',
    'assets/images/cartoon_tom.png',
    'assets/images/cricketer_dhoni.png',
  ];

  late List<String> selectedAvatars;

  @override
  void initState() {
    super.initState();
    selectedAvatars = List.from(availableAvatars);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snake & Ladder: Character Select')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [2, 3, 4].map((count) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: playerCount == count ? Colors.amber : Colors.grey[300],
                    ),
                    onPressed: () => setState(() => playerCount = count),
                    child: Text('$count Players'),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: playerCount,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Player ${index + 1} Character'),
                      trailing: DropdownButton<String>(
                        value: selectedAvatars[index],
                        items: availableAvatars.map((path) {
                          return DropdownMenuItem(
                            value: path,
                            child: Text(path.split('/').last.split('.').first),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedAvatars[index] = val);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                List<Player> players = List.generate(
                  playerCount,
                  (i) => Player(name: 'Player ${i + 1}', avatarPath: selectedAvatars[i]),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GameScreen(players: players)),
                );
              },
              child: const Text('Start Game', style: TextStyle(fontSize: 18)),
            )
          ],
        ),
      ),
    );
  }
}

// 2. Game Board & Audio/Animation Logic
class GameScreen extends StatefulWidget {
  final List<Player> players;
  const GameScreen({super.key, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late ConfettiController _confettiController;
  int currentPlayerIndex = 0;
  int diceValue = 1;
  bool isRolling = false;

  // Board snakes (Head -> Tail) and ladders (Bottom -> Top)
  final Map<int, int> ladders = {4: 14, 9: 31, 20: 38, 28: 84, 40: 59, 63: 81, 71: 91};
  final Map<int, int> snakes = {17: 7, 54: 34, 62: 19, 64: 60, 87: 24, 93: 73, 95: 75, 99: 78};

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _playSound(String fileName) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource('sounds/$fileName'));
  }

  void _rollDice() async {
    if (isRolling) return;
    setState(() => isRolling = true);

    _playSound('dice_roll.mp3');
    int roll = Random().nextInt(6) + 1;

    setState(() {
      diceValue = roll;
    });

    Player current = widget.players[currentPlayerIndex];

    if (current.position + roll <= 100) {
      current.position += roll;

      // Check Ladder
      if (ladders.containsKey(current.position)) {
        current.position = ladders[current.position]!;
        current.emotion = "happy";
        _playSound('hurray.mp3');
      }
      // Check Snake
      else if (snakes.containsKey(current.position)) {
        current.position = snakes[current.position]!;
        current.emotion = "sad";
        _playSound('snake_laugh.mp3');
      } else {
        current.emotion = "neutral";
      }

      // Check Victory
      if (current.position == 100) {
        _confettiController.play();
        _playSound('clap_whistle.mp3');
        _showWinnerDialog(current);
        setState(() => isRolling = false);
        return;
      }
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      currentPlayerIndex = (currentPlayerIndex + 1) % widget.players.length;
      isRolling = false;
    });
  }

  void _showWinnerDialog(Player winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('🎉 Winner! 🎉'),
        content: Text('${winner.name} won the match!\n(All other players are clapping)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Play Again'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Player activePlayer = widget.players[currentPlayerIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Snake & Ladder')),
      body: Stack(
        children: [
          Column(
            children: [
              // Player Status Header
              Container(
                padding: const EdgeInsets.all(12),
                color: Colors.amber.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${activePlayer.name}'s Turn", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("Emotion: ${activePlayer.emotion.toUpperCase()}", style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              // Game Board Placeholder / Grid
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.orange.shade50,
                  ),
                  child: GridView.builder(
                    reverse: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                    itemCount: 100,
                    itemBuilder: (context, index) {
                      int tileNum = index + 1;
                      var playersOnTile = widget.players.where((p) => p.position == tileNum);
                      return Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
                        child: Stack(
                          children: [
                            Positioned(top: 2, left: 2, child: Text('$tileNum', style: const TextStyle(fontSize: 8))),
                            if (playersOnTile.isNotEmpty)
                              Center(
                                child: Text(
                                  playersOnTile.map((p) => p.name[0]).join(','),
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    Text('Dice: $diceValue', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isRolling ? null : _rollDice,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                      child: Text(isRolling ? 'Rolling...' : 'Roll Dice'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}

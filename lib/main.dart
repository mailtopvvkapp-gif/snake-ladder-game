import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const SnakeLadderApp());

class SnakeLadderApp extends StatelessWidget {
  const SnakeLadderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake & Ladder Master',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const CharacterSelectScreen(),
    );
  }
}

// Character definition model
class CharacterProfile {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  const CharacterProfile({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

const List<CharacterProfile> kAllCharacters = [
  // Toon & Animated Icons
  CharacterProfile(id: 'bheem', name: 'Mighty Bheem', category: 'Cartoon Hero', icon: Icons.sports_martial_arts, primaryColor: Colors.orange, secondaryColor: Colors.amber),
  CharacterProfile(id: 'chutki', name: 'Chutki', category: 'Cartoon Hero', icon: Icons.face_3, primaryColor: Colors.pinkAccent, secondaryColor: Colors.pink),
  CharacterProfile(id: 'alien', name: 'Alien Hero', category: 'Cartoon Hero', icon: Icons.smart_toy, primaryColor: Colors.teal, secondaryColor: Colors.greenAccent),
  CharacterProfile(id: 'ninja', name: 'Shadow Ninja', category: 'Cartoon Hero', icon: Icons.security, primaryColor: Colors.black87, secondaryColor: Colors.red),

  // Cricket Icons
  CharacterProfile(id: 'batsman', name: 'Master Batsman', category: 'Cricketers', icon: Icons.sports_cricket, primaryColor: Colors.blueAccent, secondaryColor: Colors.lightBlue),
  CharacterProfile(id: 'captain', name: 'Captain Cool', category: 'Cricketers', icon: Icons.shield, primaryColor: Colors.amber, secondaryColor: Colors.orange),
  CharacterProfile(id: 'pacer', name: 'Pace King', category: 'Cricketers', icon: Icons.flash_on, primaryColor: Colors.purple, secondaryColor: Colors.deepPurpleAccent),
  CharacterProfile(id: 'spinner', name: 'Spin Magician', category: 'Cricketers', icon: Icons.album, primaryColor: Colors.redAccent, secondaryColor: Colors.deepOrange),
];

class Player {
  final int id;
  final CharacterProfile character;
  int position;
  String emotion; // "neutral", "happy", "sad"

  Player({
    required this.id,
    required this.character,
    this.position = 1,
    this.emotion = "neutral",
  });
}

// -----------------------------------------
// 1. CHARACTER SELECTION SCREEN
// -----------------------------------------
class CharacterSelectScreen extends StatefulWidget {
  const CharacterSelectScreen({super.key});

  @override
  State<CharacterSelectScreen> createState() => _CharacterSelectScreenState();
}

class _CharacterSelectScreenState extends State<CharacterSelectScreen> {
  int playerCount = 2;
  List<CharacterProfile> selected = [kAllCharacters[0], kAllCharacters[4], kAllCharacters[1], kAllCharacters[5]];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Select Your Heroes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B55),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text("Select Number of Players", style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [2, 3, 4].map((count) {
              final isSel = playerCount == count;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ChoiceChip(
                  label: Text('$count Players', style: TextStyle(color: isSel ? Colors.black : Colors.white)),
                  selected: isSel,
                  selectedColor: Colors.amberAccent,
                  backgroundColor: const Color(0xFF2D2B55),
                  onSelected: (val) {
                    if (val) setState(() => playerCount = count);
                  },
                ),
              );
            }).toList(),
          ),
          const Divider(color: Colors.white24, height: 30),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: playerCount,
              itemBuilder: (context, i) {
                return Card(
                  color: const Color(0xFF2D2B55),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Player ${i + 1}', style: const TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: kAllCharacters.length,
                            itemBuilder: (ctx, charIdx) {
                              final char = kAllCharacters[charIdx];
                              final isCharChosen = selected[i].id == char.id;
                              return GestureDetector(
                                onTap: () => setState(() => selected[i] = char),
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(
                                    color: isCharChosen ? char.primaryColor.withOpacity(0.3) : Colors.black26,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isCharChosen ? Colors.amberAccent : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 18,
                                        backgroundColor: char.primaryColor,
                                        child: Icon(char.icon, size: 18, color: Colors.white),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        char.name,
                                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(char.category, style: const TextStyle(color: Colors.white54, fontSize: 8)),
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
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amberAccent,
                foregroundColor: Colors.black87,
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                List<Player> activePlayers = List.generate(
                  playerCount,
                  (index) => Player(id: index + 1, character: selected[index]),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RichGameBoardScreen(players: activePlayers)),
                );
              },
              child: const Text('ENTER ARENA', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          )
        ],
      ),
    );
  }
}

// -----------------------------------------
// 2. VISUAL GAME BOARD SCREEN
// -----------------------------------------
class RichGameBoardScreen extends StatefulWidget {
  final List<Player> players;
  const RichGameBoardScreen({super.key, required this.players});

  @override
  State<RichGameBoardScreen> createState() => _RichGameBoardScreenState();
}

class _RichGameBoardScreenState extends State<RichGameBoardScreen> {
  late ConfettiController _confetti;
  int currentPlayer = 0;
  int diceRoll = 1;
  bool isRolling = false;
  String eventStatus = "Roll the dice to begin!";

  // Board snakes (Head -> Tail) and ladders (Bottom -> Top)
  final Map<int, int> snakes = {98: 28, 95: 56, 92: 51, 83: 19, 73: 1, 69: 33, 64: 36, 59: 17, 52: 11, 48: 9};
  final Map<int, int> ladders = {4: 14, 8: 30, 21: 42, 28: 76, 36: 44, 51: 67, 71: 91, 80: 100};

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 4));
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  void _rollDice() async {
    if (isRolling) return;
    setState(() => isRolling = true);

    int roll = Random().nextInt(6) + 1;
    setState(() => diceRoll = roll);

    Player player = widget.players[currentPlayer];
    int nextPos = player.position + roll;

    if (nextPos <= 100) {
      player.position = nextPos;
      player.emotion = "neutral";
      eventStatus = "${player.character.name} moved to $nextPos";

      // Ladder trigger
      if (ladders.containsKey(player.position)) {
        player.position = ladders[player.position]!;
        player.emotion = "happy";
        eventStatus = "🎉 HURRAY! Ladder climb to ${player.position}!";
      }
      // Snake bite trigger
      else if (snakes.containsKey(player.position)) {
        player.position = snakes[player.position]!;
        player.emotion = "sad";
        eventStatus = "🐍 HISSS! Snake bite down to ${player.position}!";
      }

      if (player.position == 100) {
        _confetti.play();
        _showWinnerModal(player);
        setState(() => isRolling = false);
        return;
      }
    } else {
      eventStatus = "Need exact roll to reach 100!";
    }

    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      currentPlayer = (currentPlayer + 1) % widget.players.length;
      isRolling = false;
    });
  }

  void _showWinnerModal(Player winner) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2D2B55),
        title: const Text('🏆 VICTORY! 🏆', textAlign: TextAlign.center, style: TextStyle(color: Colors.amberAccent, fontSize: 24, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: winner.character.primaryColor,
              child: Icon(winner.character.icon, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text('${winner.character.name} won the championship!', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            const Text('👏 Remaining players are clapping! 👏\n🎺 Whistles & Cheers! 🎺', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 13)),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amberAccent),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Play Again', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.players[currentPlayer];

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      appBar: AppBar(
        title: const Text('Snake & Ladder Master', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B55),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Top Turn & Emotion Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                color: const Color(0xFF2D2B55),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: active.character.primaryColor,
                      child: Icon(active.character.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${active.character.name}'s Turn", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(eventStatus, style: TextStyle(color: active.emotion == "happy" ? Colors.greenAccent : active.emotion == "sad" ? Colors.redAccent : Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ),
                    // Emotion Indicator Icon
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: active.emotion == 'happy' ? Colors.green.withOpacity(0.2) : active.emotion == 'sad' ? Colors.red.withOpacity(0.2) : Colors.white10,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            active.emotion == 'happy' ? Icons.sentiment_very_satisfied : active.emotion == 'sad' ? Icons.sentiment_very_dissatisfied : Icons.sentiment_neutral,
                            color: active.emotion == 'happy' ? Colors.greenAccent : active.emotion == 'sad' ? Colors.redAccent : Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            active.emotion.toUpperCase(),
                            style: TextStyle(
                              color: active.emotion == 'happy' ? Colors.greenAccent : active.emotion == 'sad' ? Colors.redAccent : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              // Game Board Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CustomPaint(
                          painter: BoardArtPainter(snakes: snakes, ladders: ladders),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 100,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                            itemBuilder: (context, index) {
                              int row = 9 - (index ~/ 10);
                              int col = (row % 2 == 1) ? 9 - (index % 10) : (index % 10);
                              int tileNumber = (row * 10) + col + 1;

                              var playersHere = widget.players.where((p) => p.position == tileNumber).toList();

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black.withOpacity(0.08), width: 0.5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 2,
                                      left: 2,
                                      child: Text(
                                        '$tileNumber',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                    if (playersHere.isNotEmpty)
                                      Center(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: playersHere.map((p) {
                                            return CircleAvatar(
                                              radius: 11,
                                              backgroundColor: p.character.primaryColor,
                                              child: Icon(p.character.icon, size: 12, color: Colors.white),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

void main() => runApp(const UltimateSnakeLadderApp());

class UltimateSnakeLadderApp extends StatelessWidget {
  const UltimateSnakeLadderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snake & Ladder: Clash of Legends',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F111A),
        fontFamily: 'Roboto',
      ),
      home: const HeroSelectionScreen(),
    );
  }
}

// -------------------------------------------------------------
// 1. CATCHY ORIGINAL CHARACTER ROSTER (Safe for Play Store)
// -------------------------------------------------------------
class HeroAvatar {
  final String id;
  final String title;
  final String tag;
  final IconData icon;
  final Color baseColor;
  final Color accentColor;
  final String cheerSoundText;

  const HeroAvatar({
    required this.id,
    required this.title,
    required this.tag,
    required this.icon,
    required this.baseColor,
    required this.accentColor,
    required this.cheerSoundText,
  });
}

const List<HeroAvatar> kGameAvatars = [
  HeroAvatar(
    id: 'astro',
    title: 'Astro Rocket',
    tag: 'Galaxy Voyager',
    icon: Icons.rocket_launch_rounded,
    baseColor: Color(0xFF00E5FF),
    accentColor: Color(0xFF00838F),
    cheerSoundText: "Whistle ~ Woohoo! 🚀",
  ),
  HeroAvatar(
    id: 'dragon',
    title: 'Fire Dragon',
    tag: 'Mythic Beast',
    icon: Icons.local_fire_department_rounded,
    baseColor: Color(0xFFFF5252),
    accentColor: Color(0xFFC62828),
    cheerSoundText: "Roar & Whistle! 🔥",
  ),
  HeroAvatar(
    id: 'cyber',
    title: 'Cyber Ninja',
    tag: 'Stealth Warrior',
    icon: Icons.electric_bolt_rounded,
    baseColor: Color(0xFF7C4DFF),
    accentColor: Color(0xFF4527A0),
    cheerSoundText: "Whistle ~ Swift Victory! ⚡",
  ),
  HeroAvatar(
    id: 'robo',
    title: 'Titan Mecha',
    tag: 'Future Bot',
    icon: Icons.smart_toy_rounded,
    baseColor: Color(0xFF00E676),
    accentColor: Color(0xFF2E7D32),
    cheerSoundText: "Beep Whistle ~ Turbo! 🤖",
  ),
  HeroAvatar(
    id: 'king',
    title: 'Royal Emperor',
    tag: 'Golden Crown',
    icon: Icons.military_tech_rounded,
    baseColor: Color(0xFFFFD700),
    accentColor: Color(0xFFF57F17),
    cheerSoundText: "Golden Whistle & Cheers! 👑",
  ),
  HeroAvatar(
    id: 'wizard',
    title: 'Cosmic Mage',
    tag: 'Spell Caster',
    icon: Icons.auto_fix_high_rounded,
    baseColor: Color(0xFFFF4081),
    accentColor: Color(0xFFC2185B),
    cheerSoundText: "Magic Whistle ~ Ascend! ✨",
  ),
];

class PlayerState {
  final int playerIndex;
  final HeroAvatar hero;
  int position;
  String mood; // "normal", "whistling", "sad"

  PlayerState({
    required this.playerIndex,
    required this.hero,
    this.position = 1,
    this.mood = "normal",
  });
}

// -------------------------------------------------------------
// 2. CHARACTER SELECTION & PLAYER COUNT SETUP
// -------------------------------------------------------------
class HeroSelectionScreen extends StatefulWidget {
  const HeroSelectionScreen({super.key});

  @override
  State<HeroSelectionScreen> createState() => _HeroSelectionScreenState();
}

class _HeroSelectionScreenState extends State<HeroSelectionScreen> {
  int totalPlayers = 2;
  List<HeroAvatar> chosenHeros = [
    kGameAvatars[0],
    kGameAvatars[1],
    kGameAvatars[2],
    kGameAvatars[3],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHOOSE YOUR CHAMPIONS', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
        centerTitle: true,
        backgroundColor: const Color(0xFF161928),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text("SELECT MATCH PLAYERS", style: TextStyle(color: Colors.white60, fontSize: 13, letterSpacing: 1)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [2, 3, 4].map((count) {
              final active = totalPlayers == count;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ChoiceChip(
                  label: Text('$count Players', style: TextStyle(color: active ? Colors.black : Colors.white, fontWeight: FontWeight.bold)),
                  selected: active,
                  selectedColor: const Color(0xFFFFD700),
                  backgroundColor: const Color(0xFF222638),
                  onSelected: (val) {
                    if (val) setState(() => totalPlayers = count);
                  },
                ),
              );
            }).toList(),
          ),
          const Divider(color: Colors.white12, height: 32),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: totalPlayers,
              itemBuilder: (ctx, pIdx) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B1E30),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Player ${pIdx + 1}', style: const TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 90,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: kGameAvatars.length,
                          itemBuilder: (context, aIdx) {
                            final avatar = kGameAvatars[aIdx];
                            final isPicked = chosenHeros[pIdx].id == avatar.id;
                            return GestureDetector(
                              onTap: () => setState(() => chosenHeros[pIdx] = avatar),
                              child: Container(
                                width: 85,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  gradient: isPicked
                                      ? LinearGradient(colors: [avatar.baseColor.withOpacity(0.4), avatar.accentColor.withOpacity(0.2)])
                                      : null,
                                  color: isPicked ? null : const Color(0xFF131522),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isPicked ? avatar.baseColor : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: avatar.baseColor,
                                      child: Icon(avatar.icon, color: Colors.black, size: 20),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(avatar.title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold), maxLines: 1),
                                    Text(avatar.tag, style: const TextStyle(fontSize: 8, color: Colors.white54)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD700),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () {
                final players = List.generate(
                  totalPlayers,
                  (i) => PlayerState(playerIndex: i + 1, hero: chosenHeros[i]),
                );
                Navigator.push(context, MaterialPageRoute(builder: (_) => ArenaBoardScreen(players: players)));
              },
              child: const Text('LAUNCH MATCH ⚔️', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
            ),
          )
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 3. MAIN ARENA BOARD & EMOTION LOGIC
// -------------------------------------------------------------
class ArenaBoardScreen extends StatefulWidget {
  final List<PlayerState> players;
  const ArenaBoardScreen({super.key, required this.players});

  @override
  State<ArenaBoardScreen> createState() => _ArenaBoardScreenState();
}

class _ArenaBoardScreenState extends State<ArenaBoardScreen> with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;
  int currentTurn = 0;
  int diceResult = 1;
  bool isRolling = false;
  String liveCommentary = "Tap 'ROLL' to roll the dice!";
  String snakeStatus = "Sleeping 😴";

  // Snakes (Bite Head -> Drops to Tail)
  final Map<int, int> snakes = {
    97: 42,
    94: 67,
    88: 24,
    78: 39,
    62: 19,
    49: 11,
    36: 8,
  };

  // Ladders (Climb Base -> Top)
  final Map<int, int> ladders = {
    5: 26,
    13: 46,
    27: 74,
    40: 64,
    50: 82,
    66: 93,
    72: 95,
  };

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

  void _executeTurn() async {
    if (isRolling) return;
    setState(() => isRolling = true);

    int roll = Random().nextInt(6) + 1;
    setState(() => diceResult = roll);

    PlayerState active = widget.players[currentTurn];
    int targetSquare = active.position + roll;

    if (targetSquare <= 100) {
      active.position = targetSquare;
      active.mood = "normal";
      snakeStatus = "Snakes watching... 👀";
      liveCommentary = "${active.hero.title} advanced to $targetSquare";

      // 1. Ladder Check (Happy Face + Whistling)
      if (ladders.containsKey(active.position)) {
        int climbTarget = ladders[active.position]!;
        active.position = climbTarget;
        active.mood = "whistling";
        snakeStatus = "Snake missed! 😤";
        liveCommentary = "🎉 HURRAY! ${active.hero.title} climbed a golden ladder! ${active.hero.cheerSoundText}";
      }
      // 2. Snake Bite Check (Snake Laughs + Player Sad Face)
      else if (snakes.containsKey(active.position)) {
        int biteTarget = snakes[active.position]!;
        active.position = biteTarget;
        active.mood = "sad";
        snakeStatus = "Snake: HAHAHA! Delicious! 😈🐍";
        liveCommentary = "🐍 CRUNCH! Snake bit ${active.hero.title}! Dropped down with a sad face.";
      }

      // 3. Victory Check
      if (active.position == 100) {
        _confetti.play();
        _showMatchVictory(active);
        setState(() => isRolling = false);
        return;
      }
    } else {
      liveCommentary = "${active.hero.title} needs exact roll to reach 100!";
    }

    await Future.delayed(const Duration(milliseconds: 1100));
    setState(() {
      currentTurn = (currentTurn + 1) % widget.players.length;
      isRolling = false;
    });
  }

  void _showMatchVictory(PlayerState champion) {
    List<PlayerState> otherPlayers = widget.players.where((p) => p.playerIndex != champion.playerIndex).toList();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1B1E30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('🏆 VICTORY CEREMONY 🏆', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: champion.hero.baseColor,
              child: Icon(champion.hero.icon, size: 45, color: Colors.black),
            ),
            const SizedBox(height: 12),
            Text('${champion.hero.title} Won the Championship!', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(champion.hero.cheerSoundText, style: const TextStyle(color: Color(0xFFFFD700), fontStyle: FontStyle.italic, fontSize: 13)),
            const SizedBox(height: 16),
            const Divider(color: Colors.white24),
            const SizedBox(height: 8),
            const Text('👏 Remaining Players Applaud & Clap! 👏', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: otherPlayers.map((other) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: other.hero.baseColor.withOpacity(0.3),
                        child: Icon(other.hero.icon, size: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      const Text('👏👏👏', style: TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD700), foregroundColor: Colors.black),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Play New Match', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.players[currentTurn];

    return Scaffold(
      appBar: AppBar(
        title: const Text('CLASH OF LEGENDS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: const Color(0xFF161928),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Top Player Status & Dynamic Emotion Panel
              Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B1E30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: active.hero.baseColor.withOpacity(0.5), width: 1.5),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: active.hero.baseColor,
                      child: Icon(active.hero.icon, color: Colors.black, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${active.hero.title} (P${active.playerIndex})", style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(liveCommentary, style: const TextStyle(fontSize: 11, color: Colors.white70), maxLines: 2, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    // Emotion Badge
                    Column(
                      children: [
                        Icon(
                          active.mood == 'whistling'
                              ? Icons.sentiment_very_satisfied_rounded
                              : active.mood == 'sad'
                                  ? Icons.sentiment_very_dissatisfied_rounded
                                  : Icons.sentiment_satisfied_rounded,
                          color: active.mood == 'whistling'
                              ? Colors.greenAccent
                              : active.mood == 'sad'
                                  ? Colors.redAccent
                                  : const Color(0xFFFFD700),
                          size: 26,
                        ),
                        Text(
                          active.mood == 'whistling'
                              ? "WHISTLE! 😙"
                              : active.mood == 'sad'
                                  ? "DULL 😞"
                                  : "FOCUSED",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: active.mood == 'whistling'
                                ? Colors.greenAccent
                                : active.mood == 'sad'
                                    ? Colors.redAccent
                                    : Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Game Board
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 15, offset: const Offset(0, 8))],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CustomPaint(
                          painter: MetallicBoardPainter(snakes: snakes, ladders: ladders),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 100,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
                            itemBuilder: (context, index) {
                              int r = 9 - (index ~/ 10);
                              int c = (r % 2 == 1) ? 9 - (index % 10) : (index % 10);
                              int tileNumber = (r * 10) + c + 1;

                              var playersOnTile = widget.players.where((p) => p.position == tileNumber).toList();

                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.5),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 2,
                                      left: 2,
                                      child: Text('$tileNumber', style: TextStyle(fontSize: 8, color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.bold)),
                                    ),
                                    if (playersOnTile.isNotEmpty)
                                      Center(
                                        child: Wrap(
                                          alignment: WrapAlignment.center,
                                          children: playersOnTile.map((p) {
                                            return CircleAvatar(
                                              radius: 11,
                                              backgroundColor: p.hero.baseColor,
                                              child: Icon(p.hero.icon, size: 13, color: Colors.black),
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
                  ),
                ),
              ),

              // Snake Taunt Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Text(snakeStatus, style: const TextStyle(fontSize: 11, color: Color(0xFFFF8A80), fontStyle: FontStyle.italic)),
              ),

              // Bottom Roll Control
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  color: Color(0xFF161928),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    // Dice Icon / Indicator
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Colors.white, Color(0xFFE0E0E0)]),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(2, 2))],
                      ),
                      child: Center(
                        child: Text('$diceResult', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD700),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: isRolling ? null : _executeTurn,
                        child: Text(
                          isRolling ? 'ROLLING...' : 'ROLL DICE 🎲',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 1.2),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          // Confetti Celebration
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 40,
              shouldLoop: false,
            ),
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. METALLIC CANVAS PAINTER (Gold Ladders & Venom Snakes)
// -------------------------------------------------------------
class MetallicBoardPainter extends CustomPainter {
  final Map<int, int> snakes;
  final Map<int, int> ladders;

  MetallicBoardPainter({required this.snakes, required this.ladders});

  Offset _getTileCoord(int tileNumber, Size size) {
    int zeroIdx = tileNumber - 1;
    int r = zeroIdx ~/ 10;
    int c = (r % 2 == 1) ? 9 - (zeroIdx % 10) : (zeroIdx % 10);
    int gridRow = 9 - r;

    double cellW = size.width / 10;
    double cellH = size.height / 10;

    return Offset((c * cellW) + (cellW / 2), (gridRow * cellH) + (cellH / 2));
  }

  @override
  void paint(Canvas canvas, Size size) {
    double cellW = size.width / 10;
    double cellH = size.height / 10;

    // 1. Grid Background
    final tileColorA = Paint()..color = const Color(0xFF202438);
    final tileColorB = Paint()..color = const Color(0xFF181B2B);

    for (int r = 0; r < 10; r++) {
      for (int c = 0; c < 10; c++) {
        canvas.drawRect(
          Rect.fromLTWH(c * cellW, r * cellH, cellW, cellH),
          (r + c) % 2 == 0 ? tileColorA : tileColorB,
        );
      }
    }

    // 2. Draw Golden Ladders
    final goldRail = Paint()
      ..color = const Color(0xFFFFD700)
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    final goldRung = Paint()
      ..color = const Color(0xFFFFEA79)
      ..strokeWidth = 2.2;

    ladders.forEach((start, end) {
      Offset pStart = _getTileCoord(start, size);
      Offset pEnd = _getTileCoord(end, size);

      double dx = pEnd.dx - pStart.dx;
      double dy = pEnd.dy - pStart.dy;
      double len = sqrt(dx * dx + dy * dy);
      double nx = -dy / len * 6.5;
      double ny = dx / len * 6.5;

      // Draw twin rails
      canvas.drawLine(Offset(pStart.dx + nx, pStart.dy + ny), Offset(pEnd.dx + nx, pEnd.dy + ny), goldRail);
      canvas.drawLine(Offset(pStart.dx - nx, pStart.dy - ny), Offset(pEnd.dx - nx, pEnd.dy - ny), goldRail);

      // Draw ladder rungs
      int steps = (len / 16).floor().clamp(3, 10);
      for (int i = 1; i < steps; i++) {
        double t = i / steps;
        double cx = pStart.dx + dx * t;
        double cy = pStart.dy + dy * t;
        canvas.drawLine(Offset(cx + nx, cy + ny), Offset(cx - nx, cy - ny), goldRung);
      }
    });

    // 3. Draw Venom Snakes (Curved bodies + Eyes + Smile/Fangs)
    final snakeBody = Paint()
      ..color = const Color(0xFFFF3366)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.5
      ..strokeCap = StrokeCap.round;

    final snakeHead = Paint()..color = const Color(0xFFC2185B);
    final snakeEye = Paint()..color = Colors.white;

    snakes.forEach((head, tail) {
      Offset pHead = _getTileCoord(head, size);
      Offset pTail = _getTileCoord(tail, size);

      Path path = Path();
      path.moveTo(pHead.dx, pHead.dy);

      double midX = (pHead.dx + pTail.dx) / 2 + 18;
      double midY = (pHead.dy + pTail.dy) / 2 - 12;

      path.quadraticBezierTo(midX, midY, pTail.dx, pTail.dy);
      canvas.drawPath(path, snakeBody);

      // Head circle & glowing eyes
      canvas.drawCircle(pHead, 7.0, snakeHead);
      canvas.drawCircle(Offset(pHead.dx - 2, pHead.dy - 2), 2.0, snakeEye);
      canvas.drawCircle(Offset(pHead.dx + 2, pHead.dy - 2), 2.0, snakeEye);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

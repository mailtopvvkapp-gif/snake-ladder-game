<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Snakes and Ladders - Theme Selector</title>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      user-select: none;
      font-family: 'Arial Rounded MT Bold', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    }

    body {
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
      background: var(--body-bg, #46253c);
      transition: background 0.3s ease;
      overflow: hidden;
    }

    .phone-container {
      position: relative;
      width: 100vw;
      max-width: 420px;
      height: 100vh;
      max-height: 900px;
      background: var(--phone-bg, #4a243f);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      align-items: center;
      padding: 16px;
      box-shadow: 0 10px 40px rgba(0, 0, 0, 0.6);
      overflow: hidden;
      transition: background 0.3s ease;
    }

    /* Ambient geometric background shapes */
    .phone-container::before {
      content: '';
      position: absolute;
      width: 260px;
      height: 260px;
      background: var(--accent-shape, #caa0e2);
      opacity: 0.35;
      transform: rotate(45deg);
      top: 60px;
      right: -130px;
      z-index: 0;
      transition: background 0.3s ease;
    }

    .phone-container::after {
      content: '';
      position: absolute;
      width: 260px;
      height: 260px;
      background: var(--accent-shape, #caa0e2);
      opacity: 0.35;
      transform: rotate(45deg);
      bottom: 60px;
      left: -130px;
      z-index: 0;
      transition: background 0.3s ease;
    }

    /* Theme Picker Toolbar */
    .theme-selector {
      z-index: 3;
      display: flex;
      gap: 8px;
      background: rgba(0, 0, 0, 0.5);
      padding: 6px 12px;
      border-radius: 20px;
      backdrop-filter: blur(4px);
    }

    .theme-btn {
      border: 2px solid transparent;
      padding: 5px 12px;
      border-radius: 12px;
      font-size: 11px;
      font-weight: 900;
      cursor: pointer;
      color: #fff;
      background: rgba(255, 255, 255, 0.15);
      transition: all 0.2s ease;
    }

    .theme-btn:hover {
      transform: scale(1.05);
    }

    .theme-btn.active {
      border-color: #fff;
      background: rgba(255, 255, 255, 0.4);
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.3);
    }

    /* Top Roll Bar */
    .top-bar {
      z-index: 2;
      align-self: flex-start;
      margin-left: -20px;
      background: #111;
      border: 4px solid #000;
      border-radius: 40px;
      display: flex;
      align-items: center;
      padding: 4px 18px 4px 6px;
      gap: 12px;
    }

    .roll-btn {
      width: 60px;
      height: 60px;
      border-radius: 50%;
      background: var(--roll-btn-bg, #8e8fa3);
      border: 4px solid #111;
      display: flex;
      align-items: center;
      justify-content: center;
      box-shadow: inset 0 3px 6px rgba(255, 255, 255, 0.4);
      color: var(--roll-btn-text, #38274a);
      font-weight: 900;
      font-size: 11px;
      cursor: pointer;
      transition: background 0.3s ease, color 0.3s ease;
    }

    .roll-btn span {
      display: block;
      transform: rotate(-35deg);
    }

    .score-badge {
      color: #72a9cc;
      font-size: 30px;
      font-weight: 900;
      min-width: 30px;
      text-align: center;
    }

    /* Board Area */
    .board-wrapper {
      position: relative;
      z-index: 2;
      width: 100%;
      aspect-ratio: 1 / 1;
      border: 5px solid #111;
      background: #111;
      border-radius: 4px;
    }

    canvas {
      width: 100%;
      height: 100%;
      display: block;
    }

    /* Bottom Controller Bar */
    .bottom-bar {
      z-index: 2;
      align-self: flex-end;
      margin-right: -20px;
      background: #111;
      border: 4px solid #000;
      border-radius: 40px;
      display: flex;
      align-items: center;
      padding: 4px 6px 4px 18px;
      gap: 14px;
    }

    .close-icon {
      width: 28px;
      height: 28px;
      border-radius: 50%;
      background: #fff;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #8c8fa6;
      font-weight: 900;
      font-size: 16px;
    }

    .bottom-score {
      color: #d15656;
      font-size: 32px;
      font-weight: 900;
    }

    .joystick-base {
      width: 62px;
      height: 62px;
      border-radius: 50%;
      background: #b82b2b;
      border: 4px solid #111;
      display: flex;
      align-items: center;
      justify-content: center;
    }

    .joystick-knob {
      width: 44px;
      height: 44px;
      border-radius: 50%;
      background: #2a2a2a;
      border: 3px solid #111;
    }
  </style>
</head>
<body>

  <div class="phone-container" id="phoneContainer">
    <!-- Skin / Theme Selection Buttons -->
    <div class="theme-selector">
      <button class="theme-btn active" onclick="setSkin('purple')">Purple</button>
      <button class="theme-btn" onclick="setSkin('classic')">Classic</button>
      <button class="theme-btn" onclick="setSkin('emerald')">Emerald</button>
      <button class="theme-btn" onclick="setSkin('midnight')">Midnight</button>
    </div>

    <!-- Top UI Bar -->
    <div class="top-bar">
      <div class="roll-btn">
        <span>ROLL</span>
      </div>
      <div class="score-badge" id="top-val">0</div>
    </div>

    <!-- Board -->
    <div class="board-wrapper">
      <canvas id="gameBoard" width="1000" height="1000"></canvas>
    </div>

    <!-- Bottom UI Bar -->
    <div class="bottom-bar">
      <div class="close-icon">&#x2715;</div>
      <div class="bottom-score">0</div>
      <div class="joystick-base">
        <div class="joystick-knob"></div>
      </div>
    </div>
  </div>

  <script>
    const canvas = document.getElementById('gameBoard');
    const ctx = canvas.getContext('2d');
    const size = 1000;
    const cellSize = size / 10;
    const root = document.documentElement;

    // Theme Palette Configurations
    const SKINS = {
      purple: {
        bodyBg: '#46253c',
        phoneBg: '#4a243f',
        accentShape: '#caa0e2',
        rollBtnBg: '#8e8fa3',
        rollBtnText: '#38274a',
        tileA: '#473166',
        tileB: '#8e8fa3',
        textA: '#ffffff',
        textB: '#241b35',
        ladderWood: '#8f5c35',
        ladderBorder: '#613b1f'
      },
      classic: {
        bodyBg: '#489eb5',
        phoneBg: '#59b8d2',
        accentShape: '#fde8c2',
        rollBtnBg: '#59d2fe',
        rollBtnText: '#ffffff',
        tileA: '#f2af69',
        tileB: '#fff6e5',
        textA: '#b26829',
        textB: '#b26829',
        ladderWood: '#9e623a',
        ladderBorder: '#5b2f15'
      },
      emerald: {
        bodyBg: '#1b3b33',
        phoneBg: '#1f483e',
        accentShape: '#a3d9a5',
        rollBtnBg: '#a3d9a5',
        rollBtnText: '#133529',
        tileA: '#275d4a',
        tileB: '#d8eedd',
        textA: '#ffffff',
        textB: '#1a4334',
        ladderWood: '#7c5332',
        ladderBorder: '#422a16'
      },
      midnight: {
        bodyBg: '#151728',
        phoneBg: '#1e213a',
        accentShape: '#4f5d8e',
        rollBtnBg: '#6c7ab8',
        rollBtnText: '#131627',
        tileA: '#2a2f52',
        tileB: '#4c5382',
        textA: '#00f0ff',
        textB: '#ffffff',
        ladderWood: '#494268',
        ladderBorder: '#1c1830'
      }
    };

    let activeSkin = SKINS.purple;

    function setSkin(skinKey) {
      if (!SKINS[skinKey]) return;
      activeSkin = SKINS[skinKey];

      // Update CSS Variables
      root.style.setProperty('--body-bg', activeSkin.bodyBg);
      root.style.setProperty('--phone-bg', activeSkin.phoneBg);
      root.style.setProperty('--accent-shape', activeSkin.accentShape);
      root.style.setProperty('--roll-btn-bg', activeSkin.rollBtnBg);
      root.style.setProperty('--roll-btn-text', activeSkin.rollBtnText);

      // Update button active state
      document.querySelectorAll('.theme-btn').forEach(btn => {
        btn.classList.toggle('active', btn.textContent.toLowerCase() === skinKey);
      });

      render();
    }

    function getCellCoords(num) {
      const index = num - 1;
      const rowFromBottom = Math.floor(index / 10);
      const col = index % 10;
      const actualCol = (rowFromBottom % 2 === 0) ? col : (9 - col);
      const actualRow = 9 - rowFromBottom;
      return {
        x: actualCol * cellSize + cellSize / 2,
        y: actualRow * cellSize + cellSize / 2
      };
    }

    function drawGrid() {
      for (let r = 0; r < 10; r++) {
        for (let c = 0; c < 10; c++) {
          const isA = (r + c) % 2 === 0;
          ctx.fillStyle = isA ? activeSkin.tileA : activeSkin.tileB;
          ctx.fillRect(c * cellSize, r * cellSize, cellSize, cellSize);

          const rowFromBottom = 9 - r;
          const num = (rowFromBottom % 2 === 0)
            ? (rowFromBottom * 10 + c + 1)
            : (rowFromBottom * 10 + (9 - c) + 1);

          ctx.font = '900 24px Arial Rounded MT Bold, sans-serif';
          ctx.fillStyle = isA ? activeSkin.textA : activeSkin.textB;
          ctx.textAlign = 'right';
          ctx.textBaseline = 'top';
          ctx.fillText(num, (c + 1) * cellSize - 10, r * cellSize + 8);
        }
      }
    }

    const ladders = [
      [2, 23], [8, 34], [28, 77], [39, 43], 
      [45, 66], [71, 91], [68, 89], [82, 100]
    ];

    function drawLadder(startNum, endNum) {
      const p1 = getCellCoords(startNum);
      const p2 = getCellCoords(endNum);

      const dx = p2.x - p1.x;
      const dy = p2.y - p1.y;
      const angle = Math.atan2(dy, dx);
      const length = Math.hypot(dx, dy);

      ctx.save();
      ctx.translate(p1.x, p1.y);
      ctx.rotate(angle);

      const width = 24;
      ctx.strokeStyle = activeSkin.ladderBorder;
      ctx.fillStyle = activeSkin.ladderWood;
      ctx.lineWidth = 4;

      // Rails
      ctx.beginPath();
      ctx.rect(0, -width / 2, length, 6);
      ctx.rect(0, width / 2 - 6, length, 6);
      ctx.fill();
      ctx.stroke();

      // Rungs
      const rungs = Math.max(3, Math.floor(length / 22));
      for (let i = 1; i < rungs; i++) {
        const x = (length / rungs) * i;
        ctx.beginPath();
        ctx.rect(x - 3, -width / 2, 6, width);
        ctx.fill();
        ctx.stroke();
      }
      ctx.restore();
    }

    const snakes = [
      { head: 97, tail: 57, color: '#c43f3f', cp: [-90, 80] },
      { head: 95, tail: 75, color: '#44964b', cp: [40, 20] },
      { head: 93, tail: 73, color: '#d1b138', cp: [-40, 30] },
      { head: 88, tail: 70, color: '#25ad8d', cp: [50, 40] },
      { head: 62, tail: 19, color: '#d1b138', cp: [-50, 60] },
      { head: 56, tail: 48, color: '#25ad8d', cp: [40, 20] },
      { head: 49, tail: 33, color: '#c43f3f', cp: [-40, 30] },
      { head: 36, tail: 17, color: '#2da7ba', cp: [-60, 40] },
      { head: 14, tail: 5,  color: '#9e64b5', cp: [-50, 20] }
    ];

    function drawSnake(snake) {
      const head = getCellCoords(snake.head);
      const tail = getCellCoords(snake.tail);

      const midX = (head.x + tail.x) / 2 + snake.cp[0];
      const midY = (head.y + tail.y) / 2 + snake.cp[1];

      // Shadow
      ctx.beginPath();
      ctx.moveTo(head.x, head.y);
      ctx.quadraticCurveTo(midX, midY, tail.x, tail.y);
      ctx.strokeStyle = 'rgba(0,0,0,0.35)';
      ctx.lineWidth = 18;
      ctx.lineCap = 'round';
      ctx.stroke();

      // Border Outline
      ctx.beginPath();
      ctx.moveTo(head.x, head.y);
      ctx.quadraticCurveTo(midX, midY, tail.x, tail.y);
      ctx.strokeStyle = '#111';
      ctx.lineWidth = 16;
      ctx.stroke();

      // Body Core
      ctx.beginPath();
      ctx.moveTo(head.x, head.y);
      ctx.quadraticCurveTo(midX, midY, tail.x, tail.y);
      ctx.strokeStyle = snake.color;
      ctx.lineWidth = 10;
      ctx.stroke();

      // Head & Features
      ctx.save();
      ctx.translate(head.x, head.y);
      
      // Eyes
      ctx.fillStyle = '#fff';
      ctx.strokeStyle = '#000';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.arc(-5, -3, 5.5, 0, Math.PI * 2);
      ctx.arc(5, -3, 5.5, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      // Pupils
      ctx.fillStyle = '#000';
      ctx.beginPath();
      ctx.arc(-5, -3, 2.5, 0, Math.PI * 2);
      ctx.arc(5, -3, 2.5, 0, Math.PI * 2);
      ctx.fill();

      // Tongue
      ctx.strokeStyle = '#d63434';
      ctx.lineWidth = 2.5;
      ctx.beginPath();
      ctx.moveTo(0, -9);
      ctx.lineTo(0, -14);
      ctx.lineTo(-3, -17);
      ctx.moveTo(0, -14);
      ctx.lineTo(3, -17);
      ctx.stroke();

      ctx.restore();
    }

    function drawPawns() {
      const p1 = getCellCoords(1);
      const tokens = [
        { x: p1.x - 22, y: p1.y + 12, fill: '#d4af37' },
        { x: p1.x + 12, y: p1.y + 12, fill: '#727786' }
      ];

      tokens.forEach(t => {
        ctx.save();
        ctx.translate(t.x, t.y);

        ctx.fillStyle = '#111';
        ctx.beginPath();
        ctx.ellipse(0, 8, 14, 6, 0, 0, Math.PI * 2);
        ctx.fill();

        ctx.fillStyle = t.fill;
        ctx.strokeStyle = '#111';
        ctx.lineWidth = 2.5;

        // Base/Body
        ctx.beginPath();
        ctx.moveTo(-10, 8);
        ctx.lineTo(-4, -4);
        ctx.lineTo(4, -4);
        ctx.lineTo(10, 8);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();

        // Head
        ctx.beginPath();
        ctx.arc(0, -10, 7, 0, Math.PI * 2);
        ctx.fill();
        ctx.stroke();

        ctx.restore();
      });
    }

    function render() {
      ctx.clearRect(0, 0, size, size);
      drawGrid();
      ladders.forEach(l => drawLadder(l[0], l[1]));
      snakes.forEach(s => drawSnake(s));
      drawPawns();
    }

    // Initialize default theme
    setSkin('purple');
  </script>
</body>
</html>
    

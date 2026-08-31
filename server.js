// server.js - Real-time Farm Dashboard Backend Server
const express = require('express');
const http = require('http');
const WebSocket = require('ws');
const path = require('path');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

app.use(express.json());
app.use(express.static(__dirname));

// In-memory accounts storage
let accounts = [
  { id: 1, name: "Bot_01", cash: 166.17, rate: 9.64, speed: 3.62, speedLv: 9, houseLv: 10, houseSlots: "17/17", petCount: 17, mainRate: 9.64, pets: ["🧙", "🧛", "🐺"], subCount: 4, subRate: 2.27, eggs: ["🟣", "🦅", "🪽"] },
  { id: 2, name: "Bot_02", cash: 61.16,  rate: 4.97, speed: 3.61, speedLv: 9, houseLv: 10, houseSlots: "17/17", petCount: 20, mainRate: 4.97, pets: ["🐺", "🐺", "🐺"], subCount: 7, subRate: 3.89, eggs: ["🌸", "✌️", "🟣"] },
  { id: 3, name: "Bot_03", cash: 7.99,   rate: 4.88, speed: 3.55, speedLv: 9, houseLv: 10, houseSlots: "17/17", petCount: 17, mainRate: 4.88, pets: ["🐉", "🦅", "🐺"], subCount: 5, subRate: 1.24, eggs: ["🟣", "👽", "🥚"] },
];

function broadcast() {
  const payload = JSON.stringify({ type: 'UPDATE_ALL', accounts });
  wss.clients.forEach(client => {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payload);
    }
  });
}

// Endpoint to receive updates from Roblox Lua scripts
app.post('/api/update', (req, res) => {
  const { name, cash, rate, speed, speedLv, houseLv, houseSlots, pets, eggs, petCount, subCount, subRate } = req.body;
  if (!name) return res.status(400).json({ error: "Account name is required" });

  let existing = accounts.find(a => a.name === name);
  if (existing) {
    existing.cash = cash !== undefined ? cash : existing.cash;
    existing.rate = rate !== undefined ? rate : existing.rate;
    existing.speed = speed !== undefined ? speed : existing.speed;
    existing.speedLv = speedLv !== undefined ? speedLv : existing.speedLv;
    existing.houseLv = houseLv !== undefined ? houseLv : existing.houseLv;
    existing.houseSlots = houseSlots || existing.houseSlots;
    if (pets) existing.pets = pets;
    if (eggs) existing.eggs = eggs;
    if (petCount) existing.petCount = petCount;
    if (subCount) existing.subCount = subCount;
    if (subRate) existing.subRate = subRate;
    existing.mainRate = existing.rate;
  } else {
    const newId = accounts.length ? Math.max(...accounts.map(a => a.id)) + 1 : 1;
    accounts.push({
      id: newId,
      name,
      cash: cash || 0,
      rate: rate || 0,
      speed: speed || 0,
      speedLv: speedLv || 1,
      houseLv: houseLv || 1,
      houseSlots: houseSlots || "1/1",
      petCount: petCount || 1,
      mainRate: rate || 0,
      pets: pets || ["🐾"],
      subCount: subCount || 0,
      subRate: subRate || 0,
      eggs: eggs || ["🥚"]
    });
  }

  broadcast();
  res.json({ success: true, message: "Account updated" });
});

// WebSocket Connection
wss.on('connection', (ws) => {
  console.log('⚡ Web Client connected');
  ws.send(JSON.stringify({ type: 'UPDATE_ALL', accounts }));
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 Dashboard server running at: http://localhost:${PORT}`);
});

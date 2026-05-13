import express from 'express';
import http from 'http';
import { Server } from 'socket.io';

const app = express();
const server = http.createServer(app);
const PORT = 8000;

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

const rooms = new Map()

app.get('/', (req, res) => {
  res.send('Server is running');
});

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('join-room', async (roomno) => {
    if (!rooms.has(roomno)) {
      rooms.set(roomno, {
        players: [],
        gamestarted: false
      })
    }
    const players = rooms.get(roomno).players;

    if (players.length < 4) {
      if (!players.includes(socket.id)) {
        players.push(socket.id);
        socket.join(roomno)
        socket.emit('room-joined')
        io.to(roomno).emit('players-update', players)
      }
      if (players.length === 4) {
        io.to(roomno).emit('game-ready')
      }
    }
  })

  socket.on('leave-room', async (roomno) => {
    socket.leave(roomno);
    const room = rooms.get(roomno);
    room.players = room.players.filter(
      (id: string) => id !== socket.id
    )
    rooms.set(roomno, room)
    io.to(roomno).emit('players-update', room.players)
    if (room.players.length === 0) {
      rooms.delete(roomno);
    }
  })

  socket.on('start-game', async (roomno) => {
    const room = rooms.get(roomno)
    if (room && room.players.length === 4) {
      room.gamestarted = true
      rooms.set(roomno, room)
      io.to(roomno).emit('game-started');

      const players = rooms.get(roomno).players;
      const gameState = new Map();
      const suits = ['Heart', 'Diamond', 'Club', 'Spade']
      const ranks = ['J', '9', 'A', '10', 'K', 'Q', '8', '7']
      suits.forEach(suit => {
        ranks.forEach(rank => {
          const randomPlayer = players[Math.floor(Math.random() * players.length)]
          if (!gameState.has(randomPlayer)) {
            gameState.set(randomPlayer, [{
              suits: suit,
              ranks: rank
            }]
            )
          } else {
            const exState = gameState.get(randomPlayer)
            gameState.set(randomPlayer, exState + {
              suits: suit,
              ranks: rank
            })
          }
        }
        )
      });
    }
  })

  socket.on('disconnect', () => {
    console.log('User disconnected');
    rooms.forEach((room, roomno) => {
      if (room.players.includes(socket.id)) {
        room.players = room.players.filter((id: string) => id !== socket.id)
      }
      socket.leave(roomno)
      rooms.set(roomno, room)
      io.to(roomno).emit('players-update', room.players)
      if (room.players.length === 0) {
        rooms.delete(roomno);
      }
    })
  });
});

server.listen(PORT, () => {
  console.log('Server started at port: ' + PORT);
});
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const PORT = 8000;

const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST']
  }
});

app.get('/', (req, res) => {
  res.send('Server is running');
});

io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('join-room', async (roomno) => {
    socket.join(roomno);
    const sockets = await io.in('roomno').fetchSockets()
    const players = sockets.map(s => s.id)
    io.to(roomno).emit('players-update', players)
  })

  socket.on('leave-room', async (roomno) => {
    socket.leave(roomno);
    const sockets = await io.in('roomno').fetchSockets()
    const players = sockets.map(s => s.id)
    io.to(roomno).emit('players-update', players)
  })

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

server.listen(PORT, () => {
  console.log('Server started at port: ' + PORT);
});
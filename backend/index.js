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

  socket.on('join-room', (roomno) => {
      socket.join(roomno);
      console.log('A user joined: ' + roomno);
  })

    socket.on('leave-room', (roomno) => {
      socket.leave(roomno);
      console.log('A user left: ' + roomno);
  })

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

server.listen(PORT, () => {
  console.log('Server started at port: ' + PORT);
});
const express = require('express')
const http = require('http');
const { Server } = require('socket.io');

const app = express;
const server = http.createServer(app);
const PORT = 8000
const io = new Server(server)

app.get('/',(req,res) => { })

io.on('connection', (socket) => {
  console.log('a user connected');
});

app.listen(PORT, () => { console.log('server started at port: ' + PORT) })
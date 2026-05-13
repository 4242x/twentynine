import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:twentynine/providers/players_provider.dart';
import 'package:twentynine/providers/ready_provider.dart';
import 'package:twentynine/providers/start_provider.dart';

class SocketService {
  late IO.Socket socket;
  late Ref ref;

  void initSocket() {
    socket = IO.io(
      'http://localhost:8000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected');
    });

    socket.on('players-update',(players){
      ref.read(playersProvider.notifier).updatePlayers(players);
    });

    socket.on('room-joined', (_){
          ref.read(readyProvider.notifier).readyState(true);
    });

    socket.on('game-started', (_){
      ref.read(startProvider.notifier).startState(true);
    });
    
    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.onConnectError((err) {
      print('Connect Error: $err');
    });
  }

  void joinRoom(String roomID) {
    socket.emit('join-room', roomID);
  }
  void leaveroom(String roomID){
    socket.emit('leave-room', roomID);
  }

  void onRoomJoined(Function() callback){
    socket.on('room-joined', (_){
          callback();
    });
  }
  void startgame(String roomID){
    socket.emit('start-game', roomID);
  }

  void dispose() {
    socket.dispose();
    socket.disconnect();
  }
}

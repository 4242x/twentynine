import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:twentynine/providers/players_provider.dart';

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

  void dispose() {
    socket.dispose();
    socket.disconnect();
  }
}

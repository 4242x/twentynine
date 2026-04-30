import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  String message = "No messages yet";
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

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

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.onConnectError((err) {
      print('Connect Error: $err');
    });
  }

  void sendMessage(String abc) {
    socket.emit('message', abc);
  }

  @override
  void dispose() {
    socket.dispose();
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Socket.IO Flutter')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(
              onPressed: () {
                sendMessage(controller.text);
              },
              child: const Text('Send Message'),
            ),
            
          ],
        ),
      ),
    );
  }
}

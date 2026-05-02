import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<String> msgs = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = IO.io(
      'http://192.168.1.2:8000',
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

    socket.on(
      'msg',
      (data) => {
        setState(() {
          msgs.add(data);
        }),
      },
    );
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
            TextField(
              controller: controller,
              onTapOutside: (_) => {
                FocusManager.instance.primaryFocus?.unfocus(),
              },
            ),
            ElevatedButton(
              onPressed: () {
                sendMessage(controller.text);
                controller.clear();
              },
              child: const Text('Send Message'),
            ),
            Flexible(
              child: ListView.builder(
                itemCount: msgs.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(msgs[index]));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

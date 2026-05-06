import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentynine/pages/waiting_page.dart';
import 'package:twentynine/providers/socket_provider.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final socket = ref.read(socketServiceProvider);
    return Scaffold(
      appBar: AppBar(title: Text('HomeScreen'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(controller: controller),
            SizedBox(height: 20),
            GestureDetector(
              child: Card(
                color: const Color.fromARGB(255, 93, 131, 136),
                child: Text('Join', style: TextStyle(fontSize: 30)),
              ),
              onTap: () {
                socket.joinRoom(controller.text.trim());
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        WaitingPage(roomID: controller.text.trim()),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

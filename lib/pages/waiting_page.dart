import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentynine/providers/socket_provider.dart';

class WaitingPage extends ConsumerStatefulWidget {
  final String roomID;
  const WaitingPage({super.key, required this.roomID});

  @override
  ConsumerState<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends ConsumerState<WaitingPage> {
  List<String> players = ['You'];

  @override
  Widget build(BuildContext context) {
    final socket = ref.read(socketServiceProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            socket.leaveroom(widget.roomID);
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(widget.roomID),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: players.length,
                itemBuilder: (context, index) {
                  return Text(players[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentynine/pages/game_page.dart';
import 'package:twentynine/providers/players_provider.dart';
import 'package:twentynine/providers/ready_provider.dart';
import 'package:twentynine/providers/socket_provider.dart';
import 'package:twentynine/providers/start_provider.dart';

class WaitingPage extends ConsumerStatefulWidget {
  final String roomID;
  const WaitingPage({super.key, required this.roomID});

  @override
  ConsumerState<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends ConsumerState<WaitingPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen(startProvider, (previous, next) {
      if (next) {
        Navigator.of(
          context,
        ).pushReplacement(
          MaterialPageRoute(builder: (context) => GamePage())
        );
      }
    });

    final socket = ref.read(socketServiceProvider);
    final players = ref.watch(playersProvider);
    final gameReady = ref.watch(readyProvider);

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
            Text('Room id: ${widget.roomID}'),
            SizedBox(height: 20),
            Text('Waiting for players...\n${players.length}/4 Players'),
            SizedBox(height: 20),
            if (gameReady)
              GestureDetector(
                child: Container(
                  color: Colors.amber,
                  child: Text('start game'),
                ),
                onTap: () {
                  socket.startgame(widget.roomID);
                },
              ),
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

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twentynine/services/socket_service.dart';

final socketServiceProvider = Provider<SocketService>((ref){
  final service = SocketService();
  service.initSocket();

  ref.onDispose((){
    service.dispose();
  });
  return service;
});
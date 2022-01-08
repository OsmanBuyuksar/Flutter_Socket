import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
//import 'package:http/io_client.dart';

void main() {
  // Dart client
  print("Geldim");
  IO.Socket socket = IO.io('http://192.168.42.254:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
  });
  socket.connect();
  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });
  socket.on('connect', (arg) {
    print("asdfads"); // world
  });
  socket.on('msg', (data) => print(data));
}
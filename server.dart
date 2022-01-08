import 'package:socket_io/socket_io.dart';

main() {
  // Dart server
  var io = new Server();
  io.on('connection', (client) {
    print('connection default namespace');
    client.on('msg', (data) {
      print('data from default => $data');
      client.emit('fromServer', "ok");
    });
  });
  io.listen(3000);
}
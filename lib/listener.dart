
import 'package:flutter/cupertino.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//server ı dinlemekten sorumlu class
class ServerListener extends ChangeNotifier{
  void ListenLocalHost(IO.Socket socket, Function func){
    socket.onConnect((data) => {  
      print("connected client side"),
      });
    socket.on('sent', (data) => {
        print("sent received data: $data"), 
        func(data),              //data verisi fonksiyon ile main e aktarılır
        notifyListeners()        //widget in tekrar olusturulması tetiklenir
      });
  }
}
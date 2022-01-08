import 'dart:async';
import 'package:mp_odev8_vsc/listener.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
void main(){
  runApp(const MyApp());  //uygulama çalıştırılır
  }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const title = 'WebSocket Uygulaması';
    return const MaterialApp(
      title: title,
      home: MyHomePage(
        title: title,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {   //ana ekranın oluşturan widget
  const MyHomePage({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();  //text i almak icin text controller tanımladık
  String s = "";  //server dan alinan verinin depolandıgı yer
  IO.Socket socketio = IO.io('http://10.0.2.2:3000',   //socket in tanımlanması
    IO.OptionBuilder()
      .setTransports(['websocket']) 
      .disableAutoConnect()  
      .build()
    );
  ServerListener serverListener = new ServerListener();  //bir server dinleyici olusturduk

  @override
  void initState() {
    print("initialized");
    socketio.connect();  //socket server a baglanır
    serverListener.ListenLocalHost(socketio, receive);  //dinleyici kurulur
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(              //girdi girmek icin textbox kısmı
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(labelText: 'Send a message'),
              ),
            ),
            const SizedBox(height: 24),
            AnimatedBuilder(         //server dan gelen verinin gosterildigi yer
              animation: Listenable.merge([serverListener]),
              builder: (context, snapshot) {
                return Container(child: Text(s));
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(  //server a veri gondermeyi tetikleyen tuş
        onPressed: _sendMessage,
        tooltip: 'Send message',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _sendMessage() {  //server a controller daki text verisi gonderilir
    //socketio.connect();
    print("msg emit sent");
    socketio.emit('msg', (_controller.text));
    //receive();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void receive(String data){  //dışarıdan gelen veriyi icerideki değişkene aktarır
    s = data;  
  }
}















class StreamSocket{
  final _socketResponse= StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose(){
    _socketResponse.close();
  }
}

StreamSocket streamSocket =StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen(){
  IO.Socket socket = IO.io('ws://localhost:3000',
      IO.OptionBuilder()
       .setTransports(['websocket']).build());

    socket.onConnect((_) {
     print('connect');
     socket.emit('msg', 'test');
    });

    //When an event recieved from server, data is added to the stream
    socket.on('event', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));

}
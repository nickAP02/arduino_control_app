import 'package:flutter/material.dart';
import 'package:rduino_app/utils/assets.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arduino control app',
      theme: ThemeData.light(),
      darkTheme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final channel = WebSocketChannel.connect(Uri.parse("ws://10.20.1.1:7000"));
  bool _isOn = false;
  String value = "OFF";
  Color color = Colors.black87;

@override
void initState() {
  super.initState();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
        //premier card
          Column(
            //width: MediaQuery.of(context).size.width,
            //height:MediaQuery.of(context).size.height,
            children :[
              SizedBox(
                height: MediaQuery.of(context).size.height/8,
                width: MediaQuery.of(context).size.width/8,
                child:  
                const Text('Arduino control app',
                textAlign: TextAlign.justify,
                strutStyle: 
                StrutStyle(
                  fontSize: 25,
                  fontFamily:"Segoe UI",
                  height:10,
                  fontStyle: FontStyle.normal,
                )
                ),
              ),
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height,maxWidth:MediaQuery.of(context).size.width),
                height: 500,
                width: MediaQuery.of(context).size.width,
                child: 
                Card(
                  child: 
                    Image.asset(amp,),
                  color: Colors.white10,
                  elevation:MediaQuery.of(context).size.width/2,
                ),
              ),
              StreamBuilder(
              stream: channel.stream,
              builder: (context,snapshot){
                return Text(
                  snapshot.hasData?'${snapshot.data}':'la lampe est éteinte'
                );
              },
          ),
            ElevatedButton
            (
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(color),
            ),
            child: !_isOn ? 
            Text
            (
              value,
              style: const TextStyle(color: Colors.white)
            ) 
            : 
            const 
            Text
            (
              "ON",
              style: TextStyle(color: Colors.white)
            ),
            onPressed: () {
              _sendAction();
            },     
          ),
            ]
          ),
        ]),
            
             
              //premier card
              /*Column(
                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                child:
                  Card(
                    child: 
                      Image.asset("./assets/conditioner.jpg",
                      width: 100,
                      height: 50,
                    ),
                    color: Colors.white10,
                    elevation:5.0,
                  ),
              ),
              ElevatedButton(
                child: const Text("Power"),
                onPressed: () {
                  // ignore: avoid_print
                  print("L'appareil a été allumé");
                },
              ),
        ],
          ),
          )*/
    );
  }
  void _sendAction(){
    
    if(_isOn ==false){
      setState(() {
      _isOn = true;  
      value = "ON";
      color = Colors.red;
      channel.sink.add(value);
      });
      
      //channel.sink.add(value);
    }
    else{
      setState(() {
        value = "OFF";
      _isOn = false;
      color = Colors.black87;
      channel.sink.add(value);
      });
      
      //channel.sink.add('Hello');
    }
  }
  @override
  void dispose(){
    channel.sink.close();
    super.dispose();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Timer? countdownTimer;
  Duration myDuration = Duration(minutes: 5);
  final player = AudioPlayer();


   @override
   void initState() {
    super.initState();
   }

  void startTimer() {

      countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void PauseTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    PauseTimer();
    setState(() => myDuration = Duration(minutes: 5));
  }

  void setCountDown() {
    setState(() {
      final seconds = myDuration.inSeconds - 1;

      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }

    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    String hours = (myDuration.inHours.remainder(24)).toString();
    String minutes = (myDuration.inMinutes.remainder(60)).toString();
    String seconds = (myDuration.inSeconds.remainder(60)).toString();

    if(myDuration.inHours.remainder(24) < 10) hours = '0$hours';
    if(myDuration.inMinutes.remainder(60) < 10) minutes = '0$minutes';
    if(myDuration.inSeconds.remainder(60) < 10) seconds = '0$seconds';

    final isRunning = countdownTimer == null ? false : countdownTimer!.isActive;
    final started = countdownTimer == null || !(countdownTimer!.isActive);

    if(myDuration.inSeconds == 0) {
      player.play();
    }
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("timer"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),

            Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget> [

            SizedBox(
             height: 280.0,
             width: 280.0,

              child: CircularProgressIndicator(
                strokeWidth: 10,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                value: ( myDuration.inSeconds / 300),
              )

            ),

            Text(
                '$hours:$minutes:$seconds',
                 style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 50),
                 ),


             ],
            ),

            const SizedBox(height: 50),


            ElevatedButton(
              onPressed: () {
                if (isRunning) {
                  PauseTimer();
                }
                else if(started) {
                  startTimer();
                }
              },
              child: Icon(
                isRunning ? Icons.pause : Icons.play_circle_fill,

                ),
              ),


            ElevatedButton(
                onPressed: () {
                  resetTimer();
                },
                child: const Icon(
                  Icons.refresh,
                  ),
                )
          ],
        ),
      ),
    );
  }
}

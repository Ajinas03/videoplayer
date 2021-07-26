import 'dart:isolate';
import 'dart:ui';

import 'package:better_player/better_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vdo_player/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  late String uid;

  void _downloadFile() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();

      final id = await FlutterDownloader.enqueue(
          url:
              "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
          savedDir: baseStorage!.path,
          fileName: "file downloading......");
    } else {
      print("no permission");
    }
  }

  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloading video");
    receivePort.listen((message) {
      print(message);
      setState(() {
        progress = message;
      });
    });
    // TODO: implement initState
    super.initState();
    secureScreen();
    uid = FirebaseAuth.instance.currentUser.uid;
    // FlutterDownloader.registerCallback(downloadCallback);
  }

  // downloadCallback(id, status, progress) {
  //   SendPort? sendPort = IsolateNameServer.lookupPortByName('Downloading video');
  //   sendPort!.send(progress);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
        backgroundColor: Colors.grey,
      ),
      body: Container(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: BetterPlayer.network(
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
                betterPlayerConfiguration:
                    BetterPlayerConfiguration(aspectRatio: 16 / 9),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  FloatingActionButton.extended(
                    onPressed: () {
                      _downloadFile();
                    },
                    icon: Icon(
                      Icons.download,
                      color: Colors.green,
                    ),
                    label: Text(
                      "Download",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

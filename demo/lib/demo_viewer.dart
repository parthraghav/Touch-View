import 'package:flutter/material.dart';
import 'package:renderer/renderer.dart';

class DemoViewer extends StatefulWidget {
  DemoViewer({Key key}) : super(key: key);

  @override
  _DemoViewerState createState() => _DemoViewerState();
}

class _DemoViewerState extends State<DemoViewer> {
  final testImagePath = "https://i.ibb.co/bQjgLSn/2.jpg";
  bool _shouldReveal = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      backgroundColor: Colors.black54,
      // backgroundColor: Colors.white,
      body: TouchView(imageName: "1.jpg", reveal: _shouldReveal),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellowAccent,
        foregroundColor: Colors.black,
        onPressed: () => setState(() {
          _shouldReveal = !_shouldReveal;
        }),
        tooltip: 'Increment',
        child: Icon(Icons.brightness_high),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

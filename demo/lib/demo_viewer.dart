import 'package:flutter/material.dart';
import 'package:renderer/renderer.dart';

class DemoViewer extends StatefulWidget {
  DemoViewer({Key key}) : super(key: key);

  @override
  _DemoViewerState createState() => _DemoViewerState();
}

class _DemoViewerState extends State<DemoViewer> {
  final testImagePath = "https://i.ibb.co/bQjgLSn/2.jpg";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      backgroundColor: Colors.black54,
      body: TouchView(imageProvider: Image.network(testImagePath)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

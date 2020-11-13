import 'package:flutter/material.dart';

class TouchView extends StatefulWidget {
  Image imageProvider;

  TouchView({Key key, this.imageProvider}) : super(key: key);

  @override
  _TouchViewState createState() => _TouchViewState();
}

class _TouchViewState extends State<TouchView> {
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    //Matrix4.translationValues(offset.dx, offset.dy, 0.0)
    return Container(
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.01 * _offset.dy)
            ..rotateY(-0.01 * _offset.dx),
          alignment: AlignmentDirectional.center,
          child: GestureDetector(
            onPanUpdate: (details) => setState(() => _offset += details.delta),
            onDoubleTap: () => setState(() => _offset = Offset.zero),
            child: widget.imageProvider,
          ),
        ),
      ),
    );
  }
}

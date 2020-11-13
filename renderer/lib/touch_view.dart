import 'package:flutter/material.dart';

class TouchView extends StatefulWidget {
  Image imageProvider;

  TouchView({Key key, this.imageProvider}) : super(key: key);

  @override
  _TouchViewState createState() => _TouchViewState();
}

class _TouchViewState extends State<TouchView> {
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  double _minScale = 1.0;
  double _maxScale = 3.0;

  @override
  Widget build(BuildContext context) {
    //Matrix4.translationValues(offset.dx, offset.dy, 0.0)
    return Container(
      child: Center(
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale)
            ..rotateZ(0),
          alignment: AlignmentDirectional.center,
          child: GestureDetector(
            onPanUpdate: (details) => setState(() => _offset += details.delta),
            onDoubleTap: () => setState(() {
              _offset = Offset.zero;
              _scale = (_scale == 1.0) ? _maxScale : _minScale;
            }),
            child: widget.imageProvider,
          ),
        ),
      ),
    );
  }
}

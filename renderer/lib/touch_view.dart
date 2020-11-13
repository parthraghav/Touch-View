import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:renderer/matrix.dart';
import 'package:renderer/measure_size_render_object.dart';

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
  Size _indicatorSize = Size(100, 100);
  Size _containerSize = Size.zero;
  Size _imageSize = Size.zero;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Matrix4.translationValues(offset.dx, offset.dy, 0.0)
    return Container(
      child: MeasureSize(
        onChange: (size) {
          print(size);
          setState(() {
            _containerSize = size;
          });
        },
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            _buildImageTransformer(),
            _buildTargetIndicator(),
          ],
        ),
      ),
    );
  }

  _buildImageTransformer() {
    return Center(
      child: MeasureSize(
        onChange: (size) {
          print(size);
          setState(() {
            _imageSize = size;
          });
        },
        child: Transform(
          transform: Matrix4.identity()
            ..translate(_offset.dx, _offset.dy)
            ..scale(_scale)
            ..rotateZ(0),
          alignment: AlignmentDirectional.center,
          child: GestureDetector(
            onPanUpdate: (details) => setState(() {
              // Configure a bounding box for the indicator
              final indicator = Rectangle(
                _containerSize.width / 2 - _indicatorSize.width / 2, // left
                _containerSize.height / 2 - _indicatorSize.height / 2, // top
                _indicatorSize.width, // width
                _indicatorSize.height, // height
              );

              // Figure out the delta from the pan
              final delta = details.delta.scale(_scale, _scale);

              // Configure the bounding box of the transformed image
              final image = Rectangle(
                  _offset.dx, // left
                  _offset.dy, // top
                  _imageSize.width, // width
                  _imageSize.height // height
                  );

              // if (delta.dy >= 0) {
              //   if (image.bottom < indicator.bottom) {
              //     _offset += Offset(0, delta.dy);
              //     print("Aight");
              //   } else {
              //     print("Oops");
              //   }
              // } else if (delta.dy < 0) {
              //   if (image.top > indicator.top) {
              //     _offset += Offset(0, delta.dy);
              //     print("Aight");
              //   } else {
              //     print("Oops");
              //   }
              // }

              // if (delta.dx >= 0) {
              //   if (image.left < indicator.left) {
              //     _offset += Offset(delta.dx, 0);
              //     print("Aight");
              //   } else {
              //     print("Oops");
              //   }
              // } else if (delta.dx < 0) {
              //   if (image.right > indicator.right) {
              //     _offset += Offset(delta.dx, 0);
              //     print("Aight");
              //   } else {
              //     print("Oops");
              //   }
              // }

              // print("dy ${delta.dy.isNegative}");
              // print("dx ${delta.dx.isNegative}");
              _offset += details.delta.scale(_scale, _scale);
            }),
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

  _buildTargetIndicator() {
    return Center(
      child: IgnorePointer(
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              width: _indicatorSize.width / 2,
              height: _indicatorSize.height / 2,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

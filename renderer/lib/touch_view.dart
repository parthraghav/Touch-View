import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:renderer/controller.dart';
import 'package:renderer/matrix.dart';
import 'package:renderer/measure_size_render_object.dart';

class TouchView extends StatefulWidget {
  String imageName;
  bool reveal;

  TouchView({Key key, this.imageName, this.reveal}) : super(key: key);

  @override
  _TouchViewState createState() => _TouchViewState();
}

class _TouchViewState extends State<TouchView> with TickerProviderStateMixin {
  TouchViewController _controller;
  Offset _offset = Offset.zero;
  double _minScale = 0.9;
  double _maxScale = 3.0;
  double _scale = 0.9;
  Size _indicatorSize = Size(100, 100);
  Size _containerSize = Size.zero;
  Size _imageSize = Size.zero;
  bool _shouldReveal = true;

  Animation _scaleAnimation;
  AnimationController _scaleAnimationController;

  @override
  void initState() {
    super.initState();
    _controller = TouchViewController(widget.imageName);

    _scaleAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _scaleAnimation = Tween(begin: _minScale, end: _maxScale).animate(
        CurvedAnimation(
            curve: Curves.easeInCubic, parent: _scaleAnimationController));
    setState(() {
      _shouldReveal = widget.reveal;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Matrix4.translationValues(offset.dx, offset.dy, 0.0)
    return Container(
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          _buildImageTransformer(),
          _buildTargetIndicator(),
        ],
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
        child: AnimatedBuilder(
          animation: _scaleAnimationController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(_offset.dx, _offset.dy)
                ..scale(_scaleAnimation.value)
                ..rotateZ(0),
              alignment: AlignmentDirectional.center,
              child: GestureDetector(
                onPanUpdate: (details) => setState(() {
                  final i = (_scale * _imageSize.width / 2 - _offset.dx) *
                      _controller.dimensions.width ~/
                      (_scale * _imageSize.width);
                  final j = (_scale * _imageSize.height / 2 - _offset.dy) *
                      _controller.dimensions.height ~/
                      (_scale * _imageSize.height);
                  print("$i,$j ${_controller.getCurrentLabel(i, j)}");

                  _offset += details.delta.scale(_scale, _scale);
                }),
                onDoubleTap: () => _didDoubleTap(),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.all(const Radius.circular(10)),
                  ),
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 200),
                    opacity: widget.reveal ? 1.0 : 0.01,
                    child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(const Radius.circular(10)),
                        child: Image.network(_controller.imagePath)),
                  ),
                ),
              ),
            );
          },
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

  _didDoubleTap() {
    setState(() {
      _offset = Offset.zero;
    });
    if (_scale == _minScale) {
      _scale = _maxScale;
      _scaleAnimationController.forward();
    } else {
      _scale = _minScale;
      _scaleAnimationController.reverse();
    }
  }
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:renderer/exif_decoder.dart';
import 'package:renderer/matrix.dart';
import 'package:renderer/tts.dart';
import 'package:throttling/throttling.dart';

import 'annotation.dart';

const APIHOST = "http://127.0.0.1:5000";

class TouchViewController {
  String _fileName;
  String _imagePath;
  Matrix _imageMat;
  Annotation _annotation;
  Function(Annotation) _didAnnotationFetch = (Annotation) {};
  TextToSpeechSynthesiser ttssynthesiser;
  String currentLabel = "";
  final Throttling throttler = new Throttling(duration: Duration(seconds: 1));
  String get imagePath => _imagePath;
  Dimensions get dimensions => Dimensions(_imageMat.w, _imageMat.h);

  TouchViewController(String fileName) : _fileName = fileName {
    ttssynthesiser = TextToSpeechSynthesiser();
    _imagePath = '$APIHOST/get_raw_image/$_fileName';
    _fetchAnnotation().then((Annotation annotation) {
      _annotation = annotation;
      _imageMat = _annotation.segmentData;
      _didAnnotationFetch(annotation);
    });
  }

  Future<Annotation> _fetchAnnotation() async {
    final endpointUrl = '$APIHOST/get_raw_annotation/';
    final requestUrl = endpointUrl + _fileName;
    final response = await http.get(requestUrl);

    if (response.statusCode == 200) {
      return Annotation.fromJson(jsonDecode(response.body));
    } else {
      throw new Exception("Error: Something went wrong");
    }
  }

  String _getLabelNameFromId(int id) {
    assert(_annotation != null);
    // print(id);
    // print(_annotation.labelData);
    if (_annotation.labelData[id] == null) print("null $id");
    return _annotation.labelData[id];
  }

  String getCurrentLabel(int x, int y) {
    if (_imageMat.includes(x, y)) {
      final labelId = _imageMat[y][x];
      final labelName = _getLabelNameFromId(labelId);
      throttler.throttle(() {
        if (labelName != currentLabel) {
          currentLabel = labelName;
        }
        ttssynthesiser.say(currentLabel);
      });
    }
    return currentLabel;
  }

  // Add a Callback
  annotationDidFetch(Function(Annotation) didAnnotationFetch) {
    _didAnnotationFetch = didAnnotationFetch;
  }
}

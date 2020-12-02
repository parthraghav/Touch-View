import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechSynthesiser {
  FlutterTts flutterTts;
  TextToSpeechSynthesiser() {
    flutterTts = FlutterTts();
  }

  Future say(String text) async {
    var result = await flutterTts.speak(text);
  }
}

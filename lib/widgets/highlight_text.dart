import 'package:flutter/material.dart';

TextSpan highlightText(
  String text,
  String highlight,
  TextStyle baseStyle,
  TextStyle highlightStyle,
  bool ignoreCase,
) {
  var sourceText = ignoreCase ? text.toLowerCase() : text;
  var targetHighlight = ignoreCase ? highlight.toLowerCase() : highlight;

  List<TextSpan> spans = [];
  int start = 0;
  int indexOfHighlight;
  do {
    indexOfHighlight = sourceText.indexOf(targetHighlight, start);
    if (indexOfHighlight < 0) {
      // no highlight
      spans.add(_normalSpan(text.substring(start), baseStyle));
      break;
    }
    if (indexOfHighlight > start) {
      // normal text before highlight
      spans
          .add(_normalSpan(text.substring(start, indexOfHighlight), baseStyle));
    }
    start = indexOfHighlight + highlight.length;
    spans.add(_highlightSpan(
        text.substring(indexOfHighlight, start), highlightStyle));
  } while (true);

  return TextSpan(children: spans);
}

TextSpan _highlightSpan(String content, TextStyle highlightStyle) {
  return TextSpan(text: content, style: highlightStyle);
}

TextSpan _normalSpan(String content, TextStyle baseStyle) {
  return TextSpan(text: content, style: baseStyle);
}

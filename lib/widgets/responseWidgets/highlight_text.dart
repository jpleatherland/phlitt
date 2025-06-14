import 'package:flutter/material.dart';

TextSpan highlightText(
  String text,
  String highlight,
  TextStyle baseStyle,
  TextStyle highlightStyle,
  bool ignoreCase,
) {
  if (highlight.isEmpty) {
    // If no highlight, return the whole text as normal
    return TextSpan(text: text, style: baseStyle);
  }
  var sourceText = ignoreCase ? text.toLowerCase() : text;
  var targetHighlight = ignoreCase ? highlight.toLowerCase() : highlight;

  List<TextSpan> spans = [];
  int start = 0;
  int indexOfHighlight;
  while (start < text.length) {
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
    if (highlight.isEmpty) break; // extra guard, but should never hit
  }

  return TextSpan(children: spans);
}

TextSpan _highlightSpan(String content, TextStyle highlightStyle) {
  return TextSpan(text: content, style: highlightStyle);
}

TextSpan _normalSpan(String content, TextStyle baseStyle) {
  return TextSpan(text: content, style: baseStyle);
}

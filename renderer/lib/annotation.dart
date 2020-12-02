import 'package:flutter/material.dart';

import 'matrix.dart';

class Annotation {
  final Dimensions dimensions;
  final Map<int, String> labelData;
  final Matrix segmentData;

  const Annotation({
    @required this.dimensions,
    @required this.labelData,
    @required this.segmentData,
  });

  factory Annotation.fromJson(Map<String, dynamic> json) {
    final _rawDimensions = json['dimensions'];
    final _rawLabelData = json['labelData'];
    final _rawSegmentData = json['segmentData'];

    assert(_rawDimensions != null &&
        _rawLabelData != null &&
        _rawSegmentData != null);

    assert(_rawDimensions['width'] != null && _rawDimensions['height'] != null);

    final dimensions =
        Dimensions(_rawDimensions['width'], _rawDimensions['height']);
    final segmentData = Matrix.fromCSV(_rawSegmentData, dimensions);

    Map<int, String> labelData = {};

    _rawLabelData.forEach((rawLabel) {
      final categoryId = rawLabel['category_id'];
      final categoryName = rawLabel['category_label'];
      labelData[categoryId] = categoryName;
    });

    return Annotation(
      dimensions: dimensions,
      labelData: labelData,
      segmentData: segmentData,
    );
  }
}

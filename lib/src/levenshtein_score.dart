import 'package:image_hash/image_score.dart';
import 'package:image_hash/image_hash.dart';

class LevenshteinScore<T extends ImageAnalytics> implements Score<T> {
  @override
  bool isEqual(T a, T b) {
    return distance(a, b)['distance'] == 0;
  }

  @override
  Map<String, double> distance(T a, T b) {
    String bytesA = a.forensics.bytes!;
    String bytesB = b.forensics.bytes!;
    int dist = 0;

    // calc

    return {
      'distance': 0.0,
      'deviation': 0.0
    };
  }
}

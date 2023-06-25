import 'package:image_hash/image_score.dart';
import 'package:image_hash/image_hash.dart';

class HammingScore<T extends ImageAnalytics> implements Score<T> {
  @override
  bool isEqual(T a, T b) {
    return distance(a, b)['distance'] == 0;
  }

  @override
  Map<String, double> distance(T a, T b) {
    String bytesA = a.forensics.hex!;
    String bytesB = b.forensics.hex!;
    int dist = 0;

    for (int i = 0; i < bytesA.length; i++) {
      if (bytesA[i] != bytesB[i]) {
        dist++;
      }
    }

    return {
      'distance': dist.toDouble(),
      'deviation': (dist * 100 / bytesA.length)
    };
  }
}

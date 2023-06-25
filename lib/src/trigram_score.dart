import 'package:image_hash/image_score.dart';
import 'package:image_hash/image_hash.dart';

extension NGram on String {
  List<String> toNGram(int n) {
    List<String> r = [];

    for (int i = 0; i <= length - n; i++) {
      r.add(substring(i, i + n));
    }

    return r;
  }
}

class TrigramScore<T extends ImageAnalytics> implements Score<T> {
  @override
  bool isEqual(T a, T b) {
    return distance(a, b)['distance'] == 0;
  }

  @override
  Map<String, double> distance(T a, T b) {
    List<String> triA = a.forensics.hex!.toNGram(3);
    List<String> triB = b.forensics.hex!.toNGram(3);
    int dist = 0;

    // get a list of distinct trigrams a x b
    int uniques = [...{...(triA + triB)}].length; // same as .toSet().toList() 🐒

    int matches = 0;
    for (int i = 0; i < triA.length; i++) {
      if (triA[i] == triB[i]) {
        matches++;
      }
    }

    dist = uniques - matches;

    return {
      'distance': dist.toDouble(),
      'deviation': 100 - (matches * 100 / uniques)
    };
  }
}
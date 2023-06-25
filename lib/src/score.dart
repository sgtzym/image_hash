import 'package:image_hash/image_hash.dart';
import 'package:image_hash/src/hamming_score.dart';
import 'package:image_hash/src/trigram_score.dart';

enum ComparingMethod { hamming, levenshtein, trigram }

// get the enum value as string
extension CompMethodParser on ComparingMethod {
  String value() {
    return (toString().split('.').last);
  }
}

abstract class Score<T extends ImageAnalytics> {
  factory Score(ComparingMethod method) {
    switch (method) {
      case ComparingMethod.hamming:
        return HammingScore();
      case ComparingMethod.trigram:
        return TrigramScore();
      default:
        ;
    }
    throw ArgumentError(
        'error: invalid compare method. method: ${method.value()}');
  }

  bool isEqual(T a, T b);
  Map<String, double> distance(T a, T b);
}

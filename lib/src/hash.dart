import 'package:image/image.dart';
import 'package:image_hash/src/calculation.dart';

enum HashFunction { average, perceptual }

// get the enum value as string
extension HashFuncParser on HashFunction {
  String value() {
    return (toString().split('.').last);
  }
}

abstract class Hash implements Calculation {
  Image img;
  var value;

  Hash(Image img) : img = img;

  String asHex() {
    var bigInt = BigInt.parse(asBytes(), radix: 2);
    return bigInt.toRadixString(16);
  }

  String asBytes() {
    return value.join('');
  }
}

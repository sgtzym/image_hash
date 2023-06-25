import 'package:image/image.dart';
import 'package:image_hash/src/hash.dart';
import 'dart:math';

class PerceptualHash extends Hash {
  PerceptualHash(Image img) : super(img);

  @override
  void calculate() {
    // resize image
    var thumbnail = copyResize(img, width: 32, height: 32);

    // crate an array of grayscale pixel values
    var grayScale = grayscale(thumbnail);

    // create a 2-dimensional pixel matrix
    var bytes = grayScale.getBytes(format: Format.luminance);

    var pixels = [];
    for (var i = 0; i < bytes.length; i += 32) {
      pixels.add(bytes.getRange(i, i + 32).toList());
    }

    // calc dct per row
    pixels = pixels.map((row) => row = _calcDCT(row)).toList();

    // calc dct per column
    var pixels2 = [];
    for (var col = 0; col < pixels.length; col++) {
      var tmp = [];
      for (var row = 0; row < pixels.length; row++) {
        tmp.add(pixels[row][col]);
      }
      pixels2.add(tmp);
    }
    pixels2 = pixels2.map((col) => col = _calcDCT(col)).toList();

    // reduce matrix to 8x8 pixels
    var top8 = [];
    for (var x = 0; x < 8; x++) {
      for (var y = 0; y < 8; y++) {
        top8.add(pixels2[x][y]);
      }
    }

    // calc median
    var m = median(top8);

    value = top8.map((px) => (px > m) ? 1 : 0);
  }

  List _calcDCT(List pixels) {
    var result = [];
    var factor = pi / pixels.length;

    for (var k = 0; k < pixels.length; k++) {
      num sum = 0;
      for (var n = 0; n < pixels.length; n++) {
        sum += pixels[n] * cos((n + 0.5) * k * factor);
      }
      sum *= sqrt(2 / pixels.length);
      if(k == 0) {
        sum *= 1 / sqrt(2);
      }
      result.add(sum);
    }

    return result;
  }

  /*
    calc median (by sorted list)
  */
  double median(List a) {
    var b = a.toList();
    b.sort();

    var middle = b.length ~/ 2;

    if (b.length % 2 == 1) {
      return b[middle];
    } else {
      return (b[middle - 1] + b[middle]) / 2.0;
    }
  }
}

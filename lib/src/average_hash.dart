import 'package:image/image.dart';
import 'package:image_hash/src/hash.dart';

class AverageHash extends Hash {
  final int _size;

  AverageHash(Image img, {int size = 8}) : _size = size, super(img);

  @override
  void calculate() {
    // resize image
    var thumbnail = copyResize(img, width: _size, height: _size);

    // crate an array of grayscale pixel values
    var grayScale = grayscale(thumbnail);

    // get the average pixel value
    var bytes = grayScale.getBytes(format: Format.luminance);
    var avg = (bytes.reduce((value, element) => value + element) / bytes.length)
        .floor();

    // set each hash bit based on whether the current pixels value is above or below the average
    value = bytes.map((b) => (b > avg) ? 1 : 0);
  }
}

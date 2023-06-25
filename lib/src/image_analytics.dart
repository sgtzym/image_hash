import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:image/image.dart';
import 'package:image_hash/src/hash.dart';
import 'package:image_hash/src/average_hash.dart';
import 'package:image_hash/src/perceptual_hash.dart';
import 'package:image_hash/src/image_forensics.dart';
import 'package:http/http.dart' as http;

// convert string to enum with ''.toEnum(MyEnum.values)
extension EnumParser on String {
  T? toEnum<T>(List<T> enumValues) {
    try {
      return enumValues.firstWhere((e) => e.toString().split('.').last == this);
    } on StateError catch (_) {
      return null;
    }
  }
}

class ImageAnalytics {
  final ImageForensics forensics;
  Image? img;
  Uint8List bytes;
  Map<String, IfdTag>? exif;
  final String _path;

  ImageAnalytics(String path)
      : forensics = ImageForensics(path: path),
        _path = path
      , bytes = Uint8List(0);

  Future<void> analyzeImage(HashFunction algorithm, {bool addExif = false}) async {
    await _readImage();
    if (addExif) {
      await _readExif();
    }
    _calcHash(algorithm);
  }

  Future<void> _readImage() async {
    bytes = _path.startsWith(RegExp(r'https?')) ? await _readImageFromUrl() : File(_path).readAsBytesSync();
    img = decodeImage(bytes);
  }

  Future<Uint8List> _readImageFromUrl() async {
    Uri url = Uri.parse(_path);
    http.Response response = await http.get(url);

    return response.bodyBytes;
  }

  Future<void> _readExif() async {
    try {
      var exif = await readExifFromBytes(bytes);

      if (exif.isEmpty) {
        stderr.writeln('error: no exif data found. file: $_path');
        return;
      }
      if (exif.containsKey('JPEGThumbnail')) {
        exif.remove('JPEGThumbnail');
      }
      if (exif.containsKey('TIFFThumbnail')) {
        exif.remove('TIFFThumbnail');
      }
      forensics.exif =
          exif.map((key, value) => MapEntry(key, value.toString()));
    } catch (_) {
      stderr.writeln('error: can not read exif data. file: $_path');
      exitCode = 2;
    }
  }

  void _calcHash(HashFunction func) {
    Hash hash;
    switch (func) {
      case HashFunction.average:
        hash = AverageHash(img!);
        break;
      case HashFunction.perceptual:
        hash = PerceptualHash(img!);
        break;
      default:
        throw ArgumentError('Invalid hash type: $func');
    }
    hash.calculate();
    forensics.hashFunction = func;
    forensics.bytes = hash.asBytes();
    forensics.hex = hash.asHex();
  }

  String getData() {
    return jsonEncode(forensics.toJson());
  }
}

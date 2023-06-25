# Image Hash

Perceptual image hashing with Dart 🎯 lang.  
Library 📚 and CLI 🖥️ for automation and embedding in other Dart/Flutter projects.

> A perceptual hash is a fingerprint of a multimedia file derived from various features from its content.  
Unlike cryptographic hash functions which rely on the avalanche effect of small changes in input leading to drastic changes in the output, perceptual hashes are "close" to one another if the features are similar.  
-- [pHash.org](http://phash.org)

## Features

- Generate **perceptual hashes** for image files (.jpg, .png, .bmp etc.)
- List **exif metadata** of image files
- Compare images and list **similarity** scores

## Requirements

- Dart 2.14.3 or higher

## Get Started

Install dependencies via terminal:

```Dart
dart pub get
```

*Breaking changes may be introduced with newer versions.*

Import the package in other projects:

```Dart
import 'package:image_hash/image_hash.dart';
```

### Create Digital Fingerprints for Images

Use different algorithms to generate unique fingerprints (perceptual hashes) for images.  
Supported hashing methods:
- Avergage
- Perceptual (DECT)

![image 1](./images/christopher-campbell-rDEOVtE7vOs-unsplash.jpg)

```
Url     : https://unsplash.com/photos/rDEOVtE7vOs
Bytes   : 1111110011010110100110000010110100101111010101000110000010001011
Hex     : fcd6982d2f54608b
```

![image 2](./images/christopher-campbell-wJkGRvG1sl8-unsplash.jpg)
```
URL     : https://unsplash.com/photos/wJkGRvG1sl8
Bytes   : 1110001111111101100000000110011000000011110110001111111011000000
Hex     : e3fd806603d8fec0
```

#### Example

``` Dart
var image = decodeImage(io.File('./images/christopher-campbell-rDEOVtE7vOs-unsplash.jpg').readAsBytesSync());

var pHash = PerceptualHash(image)..calculate();
print(pHash.asBytes());
print(pHash.asHex());
```

### Compare Images

Find similar images by using built-in comparison functions.

```
Hash 1  : fcd6982d2f54608b
Hash 2  : e3fd806603d8fec0

Hamming distance: 30
```

#### Example

``` Dart
var src1 = './images/christopher-campbell-rDEOVtE7vOs-unsplash.jpg';
var src2 = './images/christopher-campbell-wJkGRvG1sl8-unsplash.jpg';

var image1 = decodeImage(io.File(src1).readAsBytesSync());
var image2 = decodeImage(io.File(src2).readAsBytesSync());

var pHash1 = PerceptualHash(image1)..calculate();
var pHash2 = PerceptualHash(image2)..calculate();

print(pHash1.hammingDistance(pHash2));
```

Photos by [Christopher Campbell](https://unsplash.com/@chrisjoelcampbell), License: [Unsplash](https://unsplash.com/license)

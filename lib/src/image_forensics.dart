import 'package:json_annotation/json_annotation.dart';
import 'package:image_hash/src/hash.dart';
part 'image_forensics.g.dart';

@JsonSerializable()
class ImageForensics {
  final String path;

  // hash
  HashFunction? hashFunction;
  String? bytes, hex;

  // exif
  @JsonKey(includeIfNull: false)
  Map<String, String>? exif;

  ImageForensics({required this.path});

  factory ImageForensics.fromJson(Map<String, dynamic> json) =>
      _$ImageForensicsFromJson(json);

  Map<String, dynamic> toJson() => _$ImageForensicsToJson(this);
}

import 'package:image_hash/image_hash.dart';
import 'package:image_hash/image_score.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:image_hash/src/hash.dart';
part 'image_score.g.dart';

@JsonSerializable()
class ImageScore {
  final String path, bytes, hex;
  HashFunction hashFunction;
  ComparingMethod comparingMethod;
  List<Map<String, dynamic>> results;

  ImageScore(this.path, this.hashFunction, this.comparingMethod, this.bytes, this.hex, this.results);

  factory ImageScore.fromJson(Map<String, dynamic> json) =>
      _$ImageScoreFromJson(json);

  Map<String, dynamic> toJson() => _$ImageScoreToJson(this);
}

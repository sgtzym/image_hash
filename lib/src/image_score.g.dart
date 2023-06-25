// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_score.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageScore _$ImageScoreFromJson(Map<String, dynamic> json) => ImageScore(
      json['path'] as String,
      $enumDecode(_$HashFunctionEnumMap, json['hashFunction']),
      $enumDecode(_$ComparingMethodEnumMap, json['comparingMethod']),
      json['bytes'] as String,
      json['hex'] as String,
      (json['results'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ImageScoreToJson(ImageScore instance) =>
    <String, dynamic>{
      'path': instance.path,
      'bytes': instance.bytes,
      'hex': instance.hex,
      'hashFunction': _$HashFunctionEnumMap[instance.hashFunction],
      'comparingMethod': _$ComparingMethodEnumMap[instance.comparingMethod],
      'results': instance.results,
    };

const _$HashFunctionEnumMap = {
  HashFunction.average: 'average',
  HashFunction.perceptual: 'perceptual',
};

const _$ComparingMethodEnumMap = {
  ComparingMethod.hamming: 'hamming',
  ComparingMethod.levenshtein: 'levenshtein',
  ComparingMethod.trigram: 'trigram',
};

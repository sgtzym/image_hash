// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_forensics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageForensics _$ImageForensicsFromJson(Map<String, dynamic> json) =>
    ImageForensics(
      path: json['path'] as String,
    )
      ..hashFunction =
          $enumDecodeNullable(_$HashFunctionEnumMap, json['hashFunction'])
      ..bytes = json['bytes'] as String?
      ..hex = json['hex'] as String?
      ..exif = (json['exif'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$ImageForensicsToJson(ImageForensics instance) {
  final val = <String, dynamic>{
    'path': instance.path,
    'hashFunction': _$HashFunctionEnumMap[instance.hashFunction],
    'bytes': instance.bytes,
    'hex': instance.hex,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('exif', instance.exif);
  return val;
}

const _$HashFunctionEnumMap = {
  HashFunction.average: 'average',
  HashFunction.perceptual: 'perceptual',
};

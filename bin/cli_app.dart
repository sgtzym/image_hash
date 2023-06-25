import 'dart:convert';
import 'dart:io';
import 'dart:io' show Platform;
import 'package:args/args.dart';
import 'package:image_hash/src/argument.dart';
import 'package:image_hash/image_hash.dart';
import 'package:image_hash/image_score.dart';
import 'package:image_hash/src/image_score.dart';

final Argument funcArg = Argument('function', Abbrev: 'f');
final Argument compareArg = Argument('compare', Abbrev: 'c');
final Argument exifArg = Argument('exif', Abbrev: 'e');

final String cliWikiUrl =
    'http://gitlab.com/Seelenkuchenente/image_hash/-/wikis/Command-Line-App';

void main(List<String> arguments) async {
  exitCode = 0;

  ArgResults results;

  final parser = ArgParser()
    ..addOption(funcArg.Name,
        abbr: funcArg.Abbrev,
        allowed: HashFunction.values
            .map((e) => e.toString().split('.').last)
            .toList())
    ..addOption(compareArg.Name,
        abbr: compareArg.Abbrev,
        allowed: ComparingMethod.values
            .map((e) => e.toString().split('.').last)
            .toList())
    ..addFlag(exifArg.Name, abbr: exifArg.Abbrev, defaultsTo: false);

  // parse args
  try {
    results = parser.parse(arguments);
  } on FormatException catch (_) {
    // handle all false arg inputs
    await openWiki();
    return;
  }

  final paths = results.rest;

  List<ImageAnalytics> data = await getImageData(
      paths,
      results[exifArg.Name],
      results[funcArg.Name]?.toString().toEnum(HashFunction.values) ??
          HashFunction.average);

  if (data.isNotEmpty) {
    // compare images
    if (results[compareArg.Name] != null) {
      if (data.length <= 1) {
        stderr.writeln('error: no comparison object specified.');
      }
      ImageScore score = await compareImages(
          data,
          results[compareArg.Name]?.toString().toEnum(ComparingMethod.values) ??
              ComparingMethod.hamming);
      stdout.write(jsonEncode(score.toJson()));
    } else {
      // out img data
      stdout.write(data.map((e) => e.getData()).toList());
    }
  }
}

Future<List<ImageAnalytics>> getImageData(
    List<String> paths, bool addExif, HashFunction func) async {
  List<ImageAnalytics> data = [];
  for (final path in paths) {
    try {
      ImageAnalytics nltx = ImageAnalytics(path);
      await nltx.analyzeImage(func, addExif: addExif);
      data.add(nltx);
    } catch (_, stack) {
      await _handleError(path, stack);
    }
  }
  return data;
}

Future<ImageScore> compareImages(
    List<ImageAnalytics> nltx, ComparingMethod method) async {
  List<Map<String, dynamic>> results = [];

  nltx.skip(1).forEach((e) {
    Map<String, double> score = Score(method).distance(nltx[0], e);

    results.add({
      'path': e.forensics.path,
      'bytes': e.forensics.bytes,
      'hex': e.forensics.hex,
      'distance': score['distance']!.toInt(),
      'deviation': score['deviation']
    });
  });

  return ImageScore(nltx[0].forensics.path, nltx[0].forensics.hashFunction!,
      method, nltx[0].forensics.bytes!, nltx[0].forensics.hex!, results);
}

Future<void> _handleError(String path, StackTrace stack) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: path is a directory. path: $path');
  } else if (!await File(path).exists()) {
    stderr.writeln('error: path does not exist. path: $path');
  } else {
    stderr.write(stack);
    exitCode = 2;
  }
}

Future<void> openWiki() async {
  stderr.writeln(
      'error: wrong argument input. see wiki (gitlab) for help: $cliWikiUrl');
  if (Platform.isWindows) {
    try {
      await Process.run('cmd.exe', ['/k', 'start $cliWikiUrl']);
    } catch (_, stack) {
      stderr.write(stack);
      exitCode = 2;
    }
  }
}

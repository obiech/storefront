import 'dart:io';

Future<void> main() async {
  await analyzeLCoveFile('coverage/lcov.info');
}

Future<void> analyzeLCoveFile(final String path) async {
  final lCovInfoFile = File(path);
  var lineFound = 0;
  var lineHit = 0;

  final lCovLines = await lCovInfoFile.readAsLines();
  for (final line in lCovLines) {
    if (line.startsWith('LF')) {
      lineFound += int.tryParse(line.split(':').last) ?? 0;
    } else if (line.startsWith('LH')) {
      lineHit += int.tryParse(line.split(':').last) ?? 0;
    }
  }

  final coverage = lineHit / lineFound * 100;

  await writeCoverageToSVG(coverage);
}

Future<void> writeCoverageToSVG(final double coverage) async {
  final svgFile = File('coverage_badge.svg');
  final svgContent = await svgFile.readAsString();

  final regExp = RegExp(r'textLength="390">(.*?)<\/text>');

  final previousCoverageMatch = regExp.firstMatch(svgContent);
  if (previousCoverageMatch == null) return;

  final previousString = previousCoverageMatch.group(1);
  if (previousString == null) return;

  final finalSVGContent = svgContent.replaceAll(
    previousString,
    '${coverage >= 100 ? 100 : coverage.toStringAsFixed(2)}%',
  );

  await svgFile.writeAsString(finalSVGContent);
}

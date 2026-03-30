// Copyright (c) 2026 Mohamed Jlidi. All Rights Reserved.
// Unauthorized use, copying, or distribution is strictly prohibited.
// Contact: mohamedjlidi210@gmail.com

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../models/models.dart';

void exportCsv(List<IrrigationEvent> history) {
  final rows = ['Date,Duration (min),Water Used (L),Trigger'];
  for (final e in history) {
    final mins = e.endTime.difference(e.startTime).inMinutes;
    rows.add('${e.startTime.toIso8601String()},$mins,${e.waterUsedLiters.toStringAsFixed(2)},${e.trigger}');
  }
  final csv   = rows.join('\n');
  final blob  = html.Blob([csv.codeUnits]);
  final url   = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute('download', 'irrigation_history.csv')
    ..click();
  html.Url.revokeObjectUrl(url);
}


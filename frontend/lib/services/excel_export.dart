import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:file_selector/file_selector.dart';

import '../generated/mindmap.pb.dart';

/// Converts a [MindMap] to an Excel workbook and prompts the user to save it.
///
/// Each node becomes one row; the node's text is placed in the column that
/// matches its depth (root in column A, its children in column B, and so
/// on), so indentation across columns expresses the tree hierarchy directly
/// in the spreadsheet. Returns the written path, or null if cancelled.
Future<String?> exportMindMapToExcel(MindMap map, String suggestedName) async {
  const sheetName = 'MindMap';
  final excel = Excel.createExcel();
  final sheet = excel[sheetName];
  for (final name in excel.sheets.keys.toList()) {
    if (name != sheetName) excel.delete(name);
  }

  int maxDepth(Node n, int depth) {
    var deepest = depth;
    for (final c in n.children) {
      final d = maxDepth(c, depth + 1);
      if (d > deepest) deepest = d;
    }
    return deepest;
  }

  final headerStyle = CellStyle(bold: true);

  var row = 0;
  if (map.hasRoot()) {
    final depth = maxDepth(map.root, 0);
    for (var col = 0; col <= depth; col++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row));
      cell.value = TextCellValue('Level ${col + 1}');
      cell.cellStyle = headerStyle;
    }
    row++;

    void writeNode(Node n, int depth) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: depth, rowIndex: row))
          .value = TextCellValue(n.text);
      row++;
      for (final c in n.children) {
        writeNode(c, depth + 1);
      }
    }

    writeNode(map.root, 0);
  }

  final bytes = excel.save();
  if (bytes == null) return null;

  var name = suggestedName;
  if (!name.toLowerCase().endsWith('.xlsx')) name = '$name.xlsx';

  final location = await getSaveLocation(
    acceptedTypeGroups: const [
      XTypeGroup(label: 'Excel', extensions: ['xlsx']),
    ],
    suggestedName: name,
  );
  if (location == null) return null;

  final file = XFile.fromData(
    Uint8List.fromList(bytes),
    mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    name: name,
  );
  await file.saveTo(location.path);
  return location.path;
}

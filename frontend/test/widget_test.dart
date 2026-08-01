import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindmap/widgets/node_card.dart';

void main() {
  test('colorFromHex parses 6-digit and prefixed hex', () {
    expect(colorFromHex('#4A90E2', Colors.black), const Color(0xFF4A90E2));
    expect(colorFromHex('4A90E2', Colors.black), const Color(0xFF4A90E2));
  });

  test('colorFromHex falls back on garbage', () {
    expect(colorFromHex('nope', Colors.red), Colors.red);
  });
}

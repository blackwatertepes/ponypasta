import 'package:flutter_test/flutter_test.dart';

import '../../lib/data/words.dart';

void main() {
  group('getRandomWords', () {
    final List<String> original = ['alpha', 'beta', 'delta', 'gamma'];

    test('does not return duplicates', () {
      final List<String> selected = getRandomWords(original, original.length);
      selected.sort();
      expect(selected, original);
    });
  });
}

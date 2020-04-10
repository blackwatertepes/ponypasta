import 'package:flutter_test/flutter_test.dart';

import '../../lib/utils/utils.dart';

void main() {
  group('nextInList', () {
    final List<String> list = ['alpha', 'beta', 'delta', 'gamma'];

    test('returns the next', () {
      expect(nextInList(list, 'alpha'), 'beta');
    });

    test('wraps the list', () {
      expect(nextInList(list, 'gamma'), 'alpha');
    });
  });
}

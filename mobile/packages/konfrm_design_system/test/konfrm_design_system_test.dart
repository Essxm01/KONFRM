import 'package:flutter_test/flutter_test.dart';
import 'package:konfrm_design_system/konfrm_design_system.dart';

void main() {
  group('konfrm_design_system bootstrap baseline', () {
    test('exports package metadata constants correctly', () {
      expect(kKonfrmDesignSystemPackageName, 'konfrm_design_system');
      expect(kKonfrmDesignSystemVersion, '0.0.1');
      expect(kKonfrmDesignSystemFoundation, 'DF2 v1.7');
    });
  });
}

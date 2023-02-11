import 'package:fox_logging/src/helping_extensions.dart';
import 'package:test/test.dart';

class ClassWithNestedItems {
  const ClassWithNestedItems(this.items);
  final List<int> items;
}

void main() {
  group('mapMany', () {
    test('should return the items selected with the selector', () {
      // arrange
      const items = [
        ClassWithNestedItems([1, 2, 3, 4, 5]),
        ClassWithNestedItems([10, 2, 50]),
        ClassWithNestedItems([42, 42, 42, 43]),
      ];
      const expected = [1, 2, 3, 4, 5, 10, 2, 50, 42, 42, 42, 43];

      // act
      final result = items.mapMany((person) => person.items);

      // assert
      expect(result, expected);
    });
  });
}

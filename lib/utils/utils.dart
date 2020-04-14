import 'dart:math';

// Creates a random number, with a floor of the same length
// For exampe: max = 100, would actually be max 99, with min 10
int generateRandom(int max) {
  final Random random = new Random();
  final int rand = random.nextInt(max - max ~/ 10) + max ~/ 10;
  return rand;
}

nextInList(List list, item) {
  for (var i = 0; i < list.length - 1; i++) {
    if (list[i] == item) {
      return list[i + 1];
    }
  }
  return list.first;
}
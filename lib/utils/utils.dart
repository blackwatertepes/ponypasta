
nextInList(list, item) {
  for (var i = 0; i < list.length - 1; i++) {
    if (list[i] == item) {
      return list[i + 1];
    }
  }
  return list.first;
}
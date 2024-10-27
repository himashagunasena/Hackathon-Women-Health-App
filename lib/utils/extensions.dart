class Extensions {
  String capitalizeEachWord(String sentence) {
    if (sentence.isEmpty) return sentence;

    return sentence.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}

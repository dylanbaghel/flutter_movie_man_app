import 'dart:math';

final String baseUrl = "http://www.omdbapi.com";
final String apiKey = "bef9040b";


String defaultMovie() {
  List<String> words = [
    "captain",
    "avenger",
    "ironman",
    "hulk",
    "tiger",
    "arilift",
    "gold",
    "super",
    "hindi",
    "power",
    "baahubali",
    "robot",
    "rim",
    "dabangg"
  ];

  return words[new Random().nextInt(words.length)];
}
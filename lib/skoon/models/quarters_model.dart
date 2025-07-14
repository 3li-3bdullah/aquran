class QuartersModel {
  List<QuarterModel> quarters;
  QuartersModel({
    required this.quarters,
  });
  factory QuartersModel.fromMap(String json) => QuartersModel(
        quarters: List.generate(json.length,
            (index) => QuarterModel.fromMap(json as Map<String, dynamic>)),
      );
}

class QuarterModel {
  int surah;
  int ayah;
  QuarterModel({
    required this.surah,
    required this.ayah,
  });
  factory QuarterModel.fromMap(Map<String, dynamic> json) => QuarterModel(
        surah: json["surah"],
        ayah: json["ayah"],
      );
}

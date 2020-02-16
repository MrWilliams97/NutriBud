class CalorieGoal {
  double carbsPercentage;
  double fatsPercentage;
  double proteinPercentage;

  CalorieGoal({this.carbsPercentage, this.fatsPercentage, this.proteinPercentage});
  Map<String, dynamic> toJson() => {
    'carbsPercentage': carbsPercentage,
    'fatsPercentage': fatsPercentage,
    'proteinPercentage': proteinPercentage,
  };
}
class FoodDiary {

  final String foodDiaryId;
  final String userId;
  final DateTime foodDiaryDate;
  final int savedCalorieGoal;
  final int savedFatGoal;
  final int savedCarbGoal;
  final int savedProteinGoal;
  final List<String> meals;

  FoodDiary({ this.foodDiaryId, this.userId, this.foodDiaryDate, this.savedCalorieGoal, this.savedFatGoal, this.savedCarbGoal, this.savedProteinGoal, this.meals});
}
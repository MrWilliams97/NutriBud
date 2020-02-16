class FoodDiary {

  String foodDiaryId;
  String userId;
  DateTime foodDiaryDate;
  int savedCalorieGoal;
  int savedFatGoal;
  int savedCarbGoal;
  int savedProteinGoal;
  int caloriesBurned;
  //final List<String> meals;

  FoodDiary({ this.foodDiaryId, this.userId, this.foodDiaryDate, this.savedCalorieGoal, this.savedFatGoal, this.savedCarbGoal, this.savedProteinGoal, this.caloriesBurned});
}
class Food {

  final String mealId; 

  final String foodId;

  final String brandName;

  final String foodName;

  // Serving Quantity selected
  double servingQuantity;
  // Serving Size selected
  final String servingUnit;

  // KCal
  double calories;
  // g
  double fat;
  // mg
  double cholesterol;
  // mg
  double sodium;
  // g
  double carbohydrates;
  // g
  double fiber;
  // g
  double sugar;
  // g
  double protein;
  // mg
  double potassium;

  Food(
      {
      this.foodId,
      this.mealId,
      this.brandName,
      this.foodName,
      this.servingQuantity,
      this.servingUnit,
      this.calories,
      this.fat,
      this.cholesterol,
      this.sodium,
      this.carbohydrates,
      this.fiber,
      this.sugar,
      this.protein,
      this.potassium
      });

}
class Food {

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
  double cholestrol;
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
      this.brandName,
      this.foodName,
      this.servingQuantity,
      this.servingUnit,
      this.calories,
      this.fat,
      this.cholestrol,
      this.sodium,
      this.carbohydrates,
      this.fiber,
      this.sugar,
      this.protein,
      this.potassium
      });

}
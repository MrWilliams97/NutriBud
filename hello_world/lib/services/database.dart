import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:hello_world/models/meal.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Collection reference to Firestore database
  final CollectionReference foodDiariesCollection =
      Firestore.instance.collection("foodDiaries");

  final CollectionReference mealsCollection = 
    Firestore.instance.collection("meals");

  final CollectionReference foodsCollection = 
    Firestore.instance.collection("foods");

  final CollectionReference gainRivalsCollection =
    Firestore.instance.collection("gainRivalsGame");

  Future updateUserData(DateTime foodDiaryDate, String foodDiaryId) async {
    return await foodDiariesCollection.document(foodDiaryId).setData({
      "userId": uid,
      "foodDiaryDate": DateFormat("yyyy-MM-dd").format(foodDiaryDate),
      "savedCalorieGoal": null,
      "savedFatGoal": null,
      "savedCarbGoal": null,
      "savedProteinGoal": null,
      "meals": null,
    });
  }

  Future uploadFoodData(Food food) async{
    return await foodsCollection.document(food.foodId).setData({
      "mealId": food.mealId,
      "brandName": food.brandName,
      "foodName": food.foodName,
      "servingQuantity": food.servingQuantity,
      "servingUnit": food.servingUnit,
      "calories": food.calories,
      "fat": food.fat,
      "cholestrol": food.cholesterol,
      "sodium": food.sodium,
      "carbohydrates": food.carbohydrates,
      "fiber": food.fiber,
      "sugar": food.sugar,
      "protein": food.protein,
      "potassium": food.potassium
    });
  }

  Future addGainRivalsGame(GainRivalsModel model) async{
    return await gainRivalsCollection.document(model.gameName).setData({
      "users": model.users
    });
  }

  Future addMeal(String foodDiaryId, String mealId) async {
    return await mealsCollection.document(mealId).setData({
      "foodDiaryId": foodDiaryId
    });
  }

  List<FoodDiary> _foodDiariesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var userId = doc.data['userId'];
      var parsedDate = DateTime.parse(doc.data['foodDiaryDate']);
      var savedCalorieGoal = doc.data['savedCalorieGoal'];
      var savedFatGoal = doc.data['savedFatGoal'];
      var savedCarbGoal = doc.data['savedCarbGoal'];
      var savedProteinGoal = doc.data['savedProteinGoal'];
      var meals = doc.data['meals'];

      return FoodDiary(
          foodDiaryId: doc.documentID,
          userId: userId ?? '',
          foodDiaryDate: parsedDate ?? null,
          savedCalorieGoal: savedCalorieGoal ?? null,
          savedFatGoal: savedFatGoal ?? null,
          savedCarbGoal: savedCarbGoal ?? null,
          savedProteinGoal: savedProteinGoal ?? null,
          meals: meals ?? new List<String>());
    }).toList();
  }

  List<GainRivalsModel> _gainRivalsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //Create GainRivalsModels out of the documents from Firestore
      var userIds = doc.data['userIds'];

      return GainRivalsModel(gameName: doc.documentID, users: userIds);
    }).toList();
  }

  List<Food> _foodsFromSnapshot(QuerySnapshot snapshot){
    var foods = snapshot.documents.map((doc) {
      var foodId = doc.documentID;
      var mealId = doc.data['mealId'];
      var brandName = doc.data['brandName'];
      var foodName = doc.data['foodName'];
      var calories = doc.data['calories'];
      var cholesterol = doc.data['cholesterol'];
      var carbohydrates = doc.data['carbohydrates'];
      var fat = doc.data['fat'];
      var fiber = doc.data['fiber'];
      var potassium = doc.data['potassium'];
      var protein = doc.data['protein'];
      var servingQuantity = doc.data['servingQuantity'];
      var servingUnit = doc.data['servingUnit'];
      var sodium = doc.data['sodium'];
      var sugar = doc.data['sugar'];

      var food = Food(
        foodId: foodId,
        mealId: mealId,
        brandName: brandName,
        foodName: foodName,
        calories: calories,
        cholesterol: cholesterol,
        carbohydrates: carbohydrates,
        fat: fat,
        fiber: fiber,
        potassium: potassium,
        protein: protein,
        servingQuantity: servingQuantity,
        servingUnit: servingUnit,
        sodium: sodium,
        sugar: sugar
      );

      return food;
    }).toList();

    return foods;
  }

  List<Meal> _mealsFromSnapshot(QuerySnapshot snapshot){
    var meals = snapshot.documents.map((doc) {
      var mealId = doc.documentID;
      var foodDiaryId = doc.data['foodDiaryId'];

      var meal = new Meal(foodDiaryId: foodDiaryId, mealId: mealId);

      return meal;
    }).toList();

    return meals;
  }


  // Get FoodDiaries stream
  Stream<List<FoodDiary>> get foodDiaries {
    return foodDiariesCollection.snapshots().map(_foodDiariesFromSnapshot);
  }

  Stream<List<GainRivalsModel>> get gainRivalsGames {
    return gainRivalsCollection.snapshots().map(_gainRivalsFromSnapshot);
  }

  Stream<List<Food>> get foods {
    return foodsCollection.snapshots().map(_foodsFromSnapshot);
  }

  Stream<List<Meal>> get meals {
    return mealsCollection.snapshots().map(_mealsFromSnapshot);
  }
}

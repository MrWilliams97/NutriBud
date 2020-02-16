import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/calorieGoal.dart';
import 'package:hello_world/models/fitnessGoal.dart';
import 'package:hello_world/models/food.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:hello_world/models/meal.dart';
import 'package:hello_world/models/userSettings.dart';
import 'package:intl/intl.dart';

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

  final CollectionReference userSettingsCollection =
      Firestore.instance.collection("userSettings");

  Future updateUserData(FoodDiary foodDiary) async {
    //set fooddiary id and date vars
    return await foodDiariesCollection.document(foodDiary.foodDiaryId).setData({
      "userId": uid,
      "caloriesBurned": foodDiary.caloriesBurned,
      "foodDiaryDate": DateFormat("yyyy-MM-dd").format(foodDiary.foodDiaryDate),
      "savedCalorieGoal": null,
      "savedFatGoal": null,
      "savedCarbGoal": null,
      "savedProteinGoal": null,
      "meals": null,
    });
  }

  Future updateUserSettings(UserSettings userSettings) async {
    return await userSettingsCollection.document(userSettings.userId).setData({
      "dateOfBirth": DateFormat("yyyy-MM-dd").format(userSettings.dateOfBirth),
      "isMale": userSettings.isMale,
      "firstName": userSettings.firstName,
      "lastName": userSettings.lastName,
      "height": userSettings.height,
      "userName": userSettings.userName,
      "fitnessGoal": userSettings.ongoingFitnessGoal.toJson()
    });
  }

  Future uploadFoodData(Food food) async {
    return await foodsCollection.document(food.foodId).setData({
      "mealId": food.mealId,
      "brandName": food.brandName,
      "foodName": food.foodName,
      "servingQuantity": food.servingQuantity,
      "servingUnit": food.servingUnit,
      "calories": food.calories,
      "fat": food.fat,
      "cholesterol": food.cholesterol,
      "sodium": food.sodium,
      "carbohydrates": food.carbohydrates,
      "fiber": food.fiber,
      "sugar": food.sugar,
      "protein": food.protein,
      "potassium": food.potassium
    });
  }

  Future addGainRivalsGame(GainRivalsModel model) async {
    return await gainRivalsCollection
        .document(model.gameName)
        .setData({"users": model.users});
  }

  Future addMeal(String foodDiaryId, String mealId) async {
    return await mealsCollection
        .document(mealId)
        .setData({"foodDiaryId": foodDiaryId});
  }

  List<FoodDiary> _foodDiariesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var userId = doc.data['userId'];
      var caloriesBurned = doc.data['caloriesBurned'];
      var parsedDate = DateTime.parse(doc.data['foodDiaryDate']);
      var savedCalorieGoal = doc.data['savedCalorieGoal'];
      var savedFatGoal = doc.data['savedFatGoal'];
      var savedCarbGoal = doc.data['savedCarbGoal'];
      var savedProteinGoal = doc.data['savedProteinGoal'];
      //var meals = doc.data['meals'];

      return FoodDiary(
          foodDiaryId: doc.documentID,
          userId: userId ?? '',
          caloriesBurned: caloriesBurned ?? 0,
          foodDiaryDate: parsedDate ?? null,
          savedCalorieGoal: savedCalorieGoal ?? null,
          savedFatGoal: savedFatGoal ?? null,
          savedCarbGoal: savedCarbGoal ?? null,
          savedProteinGoal: savedProteinGoal ?? null
          //meals: meals ?? new List<String>()
          );
    }).toList();
  }

  List<GainRivalsModel> _gainRivalsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      //Create GainRivalsModels out of the documents from Firestore
      var userIds = doc.data['userIds'];

      return GainRivalsModel(gameName: doc.documentID, users: userIds);
    }).toList();
  }

  List<Food> _foodsFromSnapshot(QuerySnapshot snapshot) {
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
          sugar: sugar);

      return food;
    }).toList();

    return foods;
  }

  List<Meal> _mealsFromSnapshot(QuerySnapshot snapshot) {
    var meals = snapshot.documents.map((doc) {
      var mealId = doc.documentID;
      var foodDiaryId = doc.data['foodDiaryId'];

      var meal = new Meal(foodDiaryId: foodDiaryId, mealId: mealId);

      return meal;
    }).toList();

    return meals;
  }

  List<UserSettings> _userSettingsFromSnapshot(QuerySnapshot snapshot) {
    var userSettings = snapshot.documents.map((doc) {
      var userId = doc.documentID;
      var isMale = doc.data['isMale'];
      var firstName = doc.data['firstName'];
      var lastName = doc.data['lastName'];
      var dateOfBirth = DateTime.parse(doc.data['dateOfBirth']);
      var userName = doc.data['userName'];
      var height = doc.data['height'];

      try {
        var carbsPercentage =
            doc.data['fitnessGoal']['calorieGoal']['carbsPercentage'];
        var fatsPercentage =
            doc.data['fitnessGoal']['calorieGoal']['fatsPercentage'];
        var proteinPercentage =
            doc.data['fitnessGoal']['calorieGoal']['proteinPercentage'];
        CalorieGoal calorieGoal = new CalorieGoal(
            carbsPercentage: carbsPercentage,
            fatsPercentage: fatsPercentage,
            proteinPercentage: proteinPercentage);

        var fitnessGoalStartDate = doc.data['fitnessGoal']['startDate'];
        var fitnessGoalEndDate = doc.data['fitnessGoal']['endDate'];
        var fitnessGoalStartWeight = doc.data['fitnessGoal']['startWeight'];
        var fitnessGoalEndWeight = doc.data['fitnessGoal']['endWeight'];

        FitnessGoal ongoingFitnessGoal = new FitnessGoal(
            startDate: fitnessGoalStartDate,
            endDate: fitnessGoalEndDate,
            startWeight: fitnessGoalStartWeight,
            endWeight: fitnessGoalEndWeight,
            calorieGoal: calorieGoal);

        var userSetting = new UserSettings(
            userId: userId,
            isMale: isMale,
            firstName: firstName,
            lastName: lastName,
            height: height.toDouble(),
            userName: userName,
            dateOfBirth: dateOfBirth,
            ongoingFitnessGoal: ongoingFitnessGoal);

        return userSetting;
      } catch (e) {
        return new UserSettings(
            userId: userId,
            isMale: isMale,
            firstName: firstName,
            lastName: lastName,
            height: height.toDouble(),
            userName: userName,
            dateOfBirth: dateOfBirth);
      }
    }).toList();

    return userSettings;
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

  Stream<List<UserSettings>> get userSettings {
    return userSettingsCollection.snapshots().map(_userSettingsFromSnapshot);
  }
}

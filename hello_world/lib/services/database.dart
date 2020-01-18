import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:hello_world/models/gainRivalsModel.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Collection reference to Firestore database
  final CollectionReference foodDiariesCollection =
      Firestore.instance.collection("foodDiaries");

  final CollectionReference gainRivalsCollection =
    Firestore.instance.collection("gainRivalsGame");

  Future updateUserData(DateTime foodDiaryDate) async {
    return await foodDiariesCollection.document(Uuid().v4()).setData({
      "userId": uid,
      "foodDiaryDate": DateFormat("yyyy-MM-dd").format(foodDiaryDate),
      "savedCalorieGoal": null,
      "savedFatGoal": null,
      "savedCarbGoal": null,
      "savedProteinGoal": null,
      "meals": null,
    });
  }

  Future addGainRivalsGame(GainRivalsModel model) async{
    return await gainRivalsCollection.document(model.gameName).setData({
      "users": model.users
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
  // Get FoodDiaries stream
  Stream<List<FoodDiary>> get foodDiaries {
    return foodDiariesCollection.snapshots().map(_foodDiariesFromSnapshot);
  }

  Stream<List<GainRivalsModel>> get gainRivalsGames {
    return gainRivalsCollection.snapshots().map(_gainRivalsFromSnapshot);
  }
}

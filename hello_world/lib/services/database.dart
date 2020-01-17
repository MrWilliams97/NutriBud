import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/foodDiary.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //Collection reference to Firestore database
  final CollectionReference foodDiariesCollection =
      Firestore.instance.collection("foodDiaries");

  Future updateUserData(DateTime foodDiaryDate) async {
    return await foodDiariesCollection.document(uid).setData({
      "foodDiaryDate": DateFormat("yyyy-MM-dd").format(foodDiaryDate),
      "savedCalorieGoal": null,
      "savedFatGoal": null,
      "savedCarbGoal": null,
      "savedProteinGoal": null,
      "meals": null,
    });
  }

  List<FoodDiary> _foodDiariesFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      var parsedDate = DateTime.parse(doc.data['foodDiaryDate']);
      var savedCalorieGoal = doc.data['savedCalorieGoal'];
      var savedFatGoal = doc.data['savedFatGoal'];
      var savedCarbGoal = doc.data['savedCarbGoal'];
      var savedProteinGoal = doc.data['savedProteinGoal'];
      var meals = doc.data['meals'];

      if (doc.documentID == uid) {
        return FoodDiary(
            foodDiaryDate: parsedDate ?? null,
            savedCalorieGoal: savedCalorieGoal ?? null,
            savedFatGoal: savedFatGoal ?? null,
            savedCarbGoal: savedCarbGoal ?? null,
            savedProteinGoal: savedProteinGoal ?? null,
            meals: meals ?? new List<String>()
        );
      } else {
        return null;
      }
    }).toList();
  }

  // Get FoodDiaries stream
  Stream<List<FoodDiary>> get foodDiaries {
    return foodDiariesCollection.snapshots().map(_foodDiariesFromSnapshot);
  }
}

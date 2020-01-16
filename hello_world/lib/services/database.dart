import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hello_world/models/foodDiary.dart';

class DatabaseService {

  final String uid;

  DatabaseService({this.uid});

  //Collection reference to Firestore database
  final CollectionReference foodDiariesCollection = Firestore.instance.collection("foodDiaries");

  Future updateUserData() async {
    return await foodDiariesCollection.document(uid).setData({
      
    });
  }

  List<FoodDiary> _foodDiariesFromSnapshot (QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return FoodDiary(
        savedCalorieGoal: doc.data['savedCalorieGoal'] ?? '',
        savedFatGoal: doc.data['savedFatGoal'] ?? '',
        savedCarbGoal: doc.data['savedFat'] ?? '',
        savedProteinGoal: doc.data['savedProteinGoal'] ?? '',
        meals: doc.data['meals'] ?? new List<String>()
      );
    }).toList();
  }

  // Get FoodDiaries stream
  Stream<List<FoodDiary>> get foodDiaries{
    return foodDiariesCollection.snapshots()
    .map(_foodDiariesFromSnapshot);
  }
}
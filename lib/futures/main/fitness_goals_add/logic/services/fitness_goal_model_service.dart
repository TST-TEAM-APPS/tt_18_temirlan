import 'package:hive/hive.dart';
import 'package:tt_18/futures/main/fitness_goals_add/model/fitness_goal_model_hive.dart';

class FitnessGoalModelService {
  List<FitnessGoalModelHive?> _fitnessGoalList = [];

  DateTime _dateTime = DateTime.now();

  DateTime? get currentDateTime => _dateTime;
  List<FitnessGoalModelHive?> get fitnessGoalList => _fitnessGoalList;

  Future<void> loadData() async {
    final foodModelBox =
        await Hive.openBox<FitnessGoalModelHive>('_fitnessGoalList');

    _fitnessGoalList = foodModelBox.values.toList().where((e) {
      return _dateTime.isAfter(e.startedDate) &&
              _dateTime.isBefore(e.endedDate) ||
          _dateTime.month == e.startedDate.month &&
              _dateTime.day == e.startedDate.day &&
              _dateTime.year == e.startedDate.year ||
          _dateTime.month == e.endedDate.month &&
              _dateTime.day == e.endedDate.day &&
              _dateTime.year == e.endedDate.year;
    }).toList();
  }

  // Future<void> update() async {

  // }

  Future<void> updateDate(DateTime date) async {
    _dateTime = date;
    await loadData();
  }

  Future<void> setFitnessGoal(FitnessGoalModelHive fitnessGoalModel) async {
    final fitnessGoalModelBox =
        await Hive.openBox<FitnessGoalModelHive>('_fitnessGoalList');
    await fitnessGoalModelBox.add(fitnessGoalModel);
    _fitnessGoalList.add(fitnessGoalModel);
    await loadData();
  }

  Future<void> deleteFitnessGoal(FitnessGoalModelHive fitnessGoalModel) async {
    final fitnessGoalModelBox =
        await Hive.openBox<FitnessGoalModelHive>('_fitnessGoalList');
    final element = fitnessGoalModelBox.values
        .toList()
        .singleWhere((e) => e.id == fitnessGoalModel.id);
    await element.delete();
    await fitnessGoalModelBox.compact();

    await loadData();
  }

  Future<void> editFitnessGoal(FitnessGoalModelHive employeEditModel) async {
    final foodModelBox =
        await Hive.openBox<FitnessGoalModelHive>('_fitnessGoalList');
    FitnessGoalModelHive newMoaqw =
        foodModelBox.values.singleWhere((e) => e.id == employeEditModel.id);

    newMoaqw.name = employeEditModel.name;
    newMoaqw.description = employeEditModel.description;
    newMoaqw.currentProgress = employeEditModel.currentProgress;
    newMoaqw.goal = employeEditModel.goal;
    newMoaqw.imagePath = newMoaqw.imagePath;
    newMoaqw.startedDate = employeEditModel.startedDate;
    newMoaqw.endedDate = employeEditModel.endedDate;

    await newMoaqw.save();
    await loadData();
  }

  // Future<List<FoodModel?>?> getBreakfestList(DateTime date) async {
  //   final foodModelList = _fitnessGoalList;
  //   if (foodModelList.isEmpty) {
  //     return null;
  //   }

  //   final filteredModelList = foodModelList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //             .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
  //         value.typeOfFood == FoodType.breakfast;
  //   }).toList();
  //   if (filteredModelList.isNotEmpty) {
  //     filteredModelList.sort((a, b) => b!.date.compareTo(a!.date));
  //     return filteredModelList;
  //   }
  //   return null;
  // }

  // Future<List<FoodModel?>?> getLunchList(DateTime date) async {
  //   final foodModelList = _fitnessGoalList;
  //   if (foodModelList.isEmpty) {
  //     return null;
  //   }
  //   final filteredModelList = foodModelList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //             .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
  //         value.typeOfFood == FoodType.lunch;
  //   }).toList();
  //   if (filteredModelList.isNotEmpty) {
  //     return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
  //   }
  //   return null;
  // }

  // Future<int> getTotalCalories(DateTime date) async {
  //   final foodModelList = _fitnessGoalList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //         .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
  //   }).toList();
  //   if (foodModelList.isEmpty) {
  //     return 0;
  //   }
  //   return foodModelList.fold<int>(0, (sum, item) => sum + item!.calories);
  // }

  // Future<double> getTotalCarbs(DateTime date) async {
  //   final foodModelList = _fitnessGoalList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //         .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
  //   }).toList();
  //   if (foodModelList.isEmpty) {
  //     return 0;
  //   }
  //   return foodModelList.fold<double>(0, (sum, item) => sum + item!.carbs);
  // }

  // Future<double> getTotalProteins(DateTime date) async {
  //   final foodModelList = _fitnessGoalList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //         .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
  //   }).toList();
  //   if (foodModelList.isEmpty) {
  //     return 0;
  //   }
  //   return foodModelList.fold<double>(0, (sum, item) => sum + item!.proteins);
  // }

  // Future<double> getTotalFats(DateTime date) async {
  //   final foodModelList = _fitnessGoalList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //         .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
  //   }).toList();
  //   if (foodModelList.isEmpty) {
  //     return 0;
  //   }
  //   return foodModelList.fold<double>(0, (sum, item) => sum + item!.fats);
  // }

  // Future<List<FoodModel?>?> getDinnerList(DateTime date) async {
  //   final foodModelList = _fitnessGoalList;
  //   if (foodModelList.isEmpty) {
  //     return null;
  //   }

  //   final filteredModelList = foodModelList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //             .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
  //         value.typeOfFood == FoodType.dinner;
  //   }).toList();
  //   if (filteredModelList.isNotEmpty) {
  //     return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
  //   }
  //   return null;
  // }

  // Future<List<FoodModel?>?> getSnackList(DateTime date) async {
  //   final foodModelList = _fitnessGoalList;
  //   if (foodModelList.isEmpty) {
  //     return null;
  //   }

  //   final filteredModelList = foodModelList.where((value) {
  //     return DateTime(value!.date.day, value.date.month, value.date.year)
  //             .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
  //         value.typeOfFood == FoodType.snack;
  //   }).toList();
  //   if (filteredModelList.isNotEmpty) {
  //     return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
  //   }
  //   return null;
  // }
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:tt_18/core/app_fonts.dart';
import 'package:tt_18/core/btm.dart';
import 'package:tt_18/core/colors.dart';
import 'package:tt_18/futures/food/food_screen.dart';
import 'package:tt_18/futures/food/model/food_model.dart';
import 'package:tt_18/futures/main/fitness_goals_add/logic/viewModel/fintess_goal_view_model.dart';
import 'package:tt_18/futures/main/main_screen.dart';
import 'package:tt_18/futures/settings/settings_screen.dart';
import 'package:tt_18/futures/training/training_screen.dart';

class FoodViewModelState {
  List<FoodModel?>? foodBreakfestList;
  List<FoodModel?>? foodLunchList;
  List<FoodModel?>? foodDinnerList;
  List<FoodModel?>? foodSnakList;
  int? totalCalories;
  double? totalProteins;
  double? totalFats;
  double? totalCarbs;
  DateTime? currentDateTime;

  FoodViewModelState({
    this.totalCalories,
    this.foodBreakfestList,
    this.foodDinnerList,
    this.foodLunchList,
    this.foodSnakList,
    this.totalCarbs,
    this.totalFats,
    this.totalProteins,
    this.currentDateTime,
  });
}

class FoodViewModel extends ChangeNotifier {
  final FoodService _foodService = FoodService();
  FoodViewModelState _state = FoodViewModelState();
  FoodViewModelState get state => _state;

  void loadData() async {
    await _foodService.loadData();
    _state = FoodViewModelState(
      foodBreakfestList: _foodService._foodBreakfestList,
      foodDinnerList: _foodService._foodDinnerList,
      foodLunchList: _foodService._foodLunchList,
      foodSnakList: _foodService._foodLunchList,
      totalCalories: _foodService._totalCalories,
      totalCarbs: _foodService._totalCarbs,
      totalFats: _foodService.totalFats,
      totalProteins: _foodService._totalProteins,
      currentDateTime: _foodService._dateTime,
    );
    notifyListeners();
  }

  FoodViewModel() {
    loadData();
  }

  void onDeleteFood(FoodModel foodModel) async {
    await _foodService.deleteFood(foodModel);
    _state = FoodViewModelState(
      foodBreakfestList: _foodService._foodBreakfestList,
      foodDinnerList: _foodService._foodDinnerList,
      foodLunchList: _foodService._foodLunchList,
      foodSnakList: _foodService._foodLunchList,
      totalCalories: _foodService._totalCalories,
      totalCarbs: _foodService._totalCarbs,
      totalFats: _foodService.totalFats,
      totalProteins: _foodService._totalProteins,
      currentDateTime: _foodService._dateTime,
    );
    notifyListeners();
  }

  void onUpdatedFood(FoodModel foodModel) {
    _foodService.editFood(foodModel).then((_) {
      _state = FoodViewModelState(
        foodBreakfestList: _foodService._foodBreakfestList,
        foodDinnerList: _foodService._foodDinnerList,
        foodLunchList: _foodService._foodLunchList,
        foodSnakList: _foodService._foodSnakList,
        totalCalories: _foodService._totalCalories,
        totalCarbs: _foodService._totalCarbs,
        totalFats: _foodService._totalFats,
        totalProteins: _foodService._totalProteins,
        currentDateTime: _foodService._dateTime,
      );
    });
    notifyListeners();
  }

  void onUpdatedDate(DateTime date) {
    _foodService.updateDate(date).then((_) {
      _state = FoodViewModelState(
        foodBreakfestList: _foodService._foodBreakfestList,
        foodDinnerList: _foodService._foodDinnerList,
        foodLunchList: _foodService._foodLunchList,
        foodSnakList: _foodService._foodSnakList,
        totalCalories: _foodService._totalCalories,
        totalCarbs: _foodService._totalCarbs,
        totalFats: _foodService._totalFats,
        totalProteins: _foodService._totalProteins,
        currentDateTime: _foodService._dateTime,
      );
    });

    notifyListeners();
  }

  Future<void> onFoodItemAdded(FoodModel foodModel) async {
    _foodService.setFood(foodModel).then((_) {
      _state = FoodViewModelState(
        foodBreakfestList: _foodService._foodBreakfestList,
        foodDinnerList: _foodService._foodDinnerList,
        foodLunchList: _foodService._foodLunchList,
        foodSnakList: _foodService._foodSnakList,
        totalCalories: _foodService._totalCalories,
        totalCarbs: _foodService._totalCarbs,
        totalFats: _foodService._totalFats,
        totalProteins: _foodService._totalProteins,
        currentDateTime: _foodService._dateTime,
      );
      notifyListeners();
    });
  }
}

class FoodService {
  List<FoodModel?> _foodList = [];
  List<FoodModel?>? _foodBreakfestList;
  List<FoodModel?>? _foodLunchList;
  List<FoodModel?>? _foodDinnerList;
  List<FoodModel?>? _foodSnakList;
  int? _totalCalories;
  double? _totalProteins;
  double? _totalCarbs;
  double? _totalFats;

  DateTime _dateTime = DateTime.now();

  List<FoodModel?>? get foodBreakfestList => _foodBreakfestList;
  List<FoodModel?>? get foodLunchList => _foodLunchList;
  List<FoodModel?>? get foodDinnerList => _foodDinnerList;
  List<FoodModel?>? get foodSnakList => _foodSnakList;
  int? get totalCalories => _totalCalories;
  double? get totalProteins => _totalProteins;
  double? get totalCarbs => _totalCarbs;
  double? get totalFats => _totalFats;
  DateTime? get currentDateTime => _dateTime;

  Future<void> loadData() async {
    final foodModelBox = await Hive.openBox<FoodModel>('_foodList');
    _foodList = foodModelBox.values.toList();
    await update();
  }

  Future<void> update() async {
    _foodBreakfestList = await getBreakfestList(_dateTime);
    _foodLunchList = await getLunchList(_dateTime);
    _foodDinnerList = await getDinnerList(_dateTime);
    _foodSnakList = await getSnackList(_dateTime);
    _totalCalories = await getTotalCalories(_dateTime);
    _totalCarbs = await getTotalCarbs(_dateTime);
    _totalFats = await getTotalFats(_dateTime);

    _totalProteins = await getTotalProteins(_dateTime);
  }

  Future<void> updateDate(DateTime date) async {
    _dateTime = date;
    await update();
  }

  Future<void> setFood(FoodModel foodModel) async {
    final foodModelBox = await Hive.openBox<FoodModel>('_foodList');
    await foodModelBox.add(foodModel);
    _foodList.add(foodModel);
    await update();
  }

  Future<void> deleteFood(FoodModel foodModel) async {
    final foodModelBox = await Hive.openBox<FoodModel>('_foodList');
    final foodModelList = foodModelBox.values.toList();
    if (foodModelList.contains(foodModel)) {
      _foodList.remove(foodModel);
      await foodModelBox.delete(foodModel);
    }
    await update();
  }

  Future<void> editFood(FoodModel foodEditModel) async {
    final foodModelBox = await Hive.openBox<FoodModel>('_foodList');

    int foodToUpdateIndex = _foodList.indexWhere((food) {
      print('${food?.id} ${foodEditModel.id}');
      return food?.id == foodEditModel.id;
    });
    if (foodToUpdateIndex != -1) {
      _foodList[foodToUpdateIndex] = foodEditModel;
    }

    final newValue = _foodList[foodToUpdateIndex]!.copyWith(
      quantity: foodEditModel.quantity,
      proteins: foodEditModel.proteins,
      typeOfFood: foodEditModel.typeOfFood,
      calories: foodEditModel.calories,
      carbs: foodEditModel.carbs,
      fats: foodEditModel.fats,
      quantityType: foodEditModel.quantityType,
      name: foodEditModel.name,
    );

    await foodModelBox.put(newValue.id.toString(), newValue);
    await update();
  }

  Future<List<FoodModel?>?> getBreakfestList(DateTime date) async {
    final foodModelList = _foodList;
    if (foodModelList.isEmpty) {
      return null;
    }

    final filteredModelList = foodModelList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
              .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
          value.typeOfFood == FoodType.breakfast;
    }).toList();
    if (filteredModelList.isNotEmpty) {
      filteredModelList.sort((a, b) => b!.date.compareTo(a!.date));
      return filteredModelList;
    }
    return null;
  }

  Future<List<FoodModel?>?> getLunchList(DateTime date) async {
    final foodModelList = _foodList;
    if (foodModelList.isEmpty) {
      return null;
    }
    final filteredModelList = foodModelList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
              .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
          value.typeOfFood == FoodType.lunch;
    }).toList();
    if (filteredModelList.isNotEmpty) {
      return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
    }
    return null;
  }

  Future<int> getTotalCalories(DateTime date) async {
    final foodModelList = _foodList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
          .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
    }).toList();
    if (foodModelList.isEmpty) {
      return 0;
    }
    return foodModelList.fold<int>(0, (sum, item) => sum + item!.calories);
  }

  Future<double> getTotalCarbs(DateTime date) async {
    final foodModelList = _foodList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
          .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
    }).toList();
    if (foodModelList.isEmpty) {
      return 0;
    }
    return foodModelList.fold<double>(0, (sum, item) => sum + item!.carbs);
  }

  Future<double> getTotalProteins(DateTime date) async {
    final foodModelList = _foodList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
          .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
    }).toList();
    if (foodModelList.isEmpty) {
      return 0;
    }
    return foodModelList.fold<double>(0, (sum, item) => sum + item!.proteins);
  }

  Future<double> getTotalFats(DateTime date) async {
    final foodModelList = _foodList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
          .isAtSameMomentAs(DateTime(date.day, date.month, date.year));
    }).toList();
    if (foodModelList.isEmpty) {
      return 0;
    }
    return foodModelList.fold<double>(0, (sum, item) => sum + item!.fats);
  }

  Future<List<FoodModel?>?> getDinnerList(DateTime date) async {
    final foodModelList = _foodList;
    if (foodModelList.isEmpty) {
      return null;
    }

    final filteredModelList = foodModelList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
              .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
          value.typeOfFood == FoodType.dinner;
    }).toList();
    if (filteredModelList.isNotEmpty) {
      return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
    }
    return null;
  }

  Future<List<FoodModel?>?> getSnackList(DateTime date) async {
    final foodModelList = _foodList;
    if (foodModelList.isEmpty) {
      return null;
    }

    final filteredModelList = foodModelList.where((value) {
      return DateTime(value!.date.day, value.date.month, value.date.year)
              .isAtSameMomentAs(DateTime(date.day, date.month, date.year)) &&
          value.typeOfFood == FoodType.snack;
    }).toList();
    if (filteredModelList.isNotEmpty) {
      return filteredModelList..sort((a, b) => b!.date.compareTo(a!.date));
    }
    return null;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<PageModel> _pages = [
    PageModel(
      page: ChangeNotifierProvider(
          create: (_) => ActivityViewModel(), child: const MainScreen()),
      iconPath: 'assets/icons/main.png',
    ),
    PageModel(
      page: const TrainingScreen(),
      iconPath: 'assets/icons/training.png',
    ),
    PageModel(
      page: ChangeNotifierProvider(
          create: (_) => FoodViewModel(), child: const FoodScreen()),
      iconPath: 'assets/icons/food.png',
    ),
    PageModel(
      page: ChangeNotifierProvider(
          create: (_) => ActivityViewModel(), child: const SettingsScreen()),
      iconPath: 'assets/icons/settings.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex].page,
      bottomNavigationBar: WoDownBar(
        onPageChanged: (index) {
          _currentIndex = index;
          setState(() {});
        },
        pages: _pages,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_pages[index].iconPath != null)
                  Image.asset(
                    _pages[index].iconPath!,
                    color: _currentIndex == index
                        ? AppColors.primary
                        : AppColors.outlineGrey,
                    width: 24,
                  ),
                if (_pages[index].title != null)
                  const SizedBox(
                    height: 3,
                  ),
                if (_pages[index].title != null)
                  Text(
                    _pages[index].title!,
                    style: AppFonts.displaySmall.copyWith(
                      color: _currentIndex == index
                          ? Colors.white
                          : AppColors.outlineGrey,
                    ),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}

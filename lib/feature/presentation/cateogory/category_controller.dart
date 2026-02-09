import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:imposter/feature/data/model/category/category_model.dart';

class CategoryController {
  // Barcha kategoriyalar ro'yxati
  final ValueNotifier<List<CategoryModel>> categories = ValueNotifier<List<CategoryModel>>([]);

  // Tanlangan kategoriya ID'lari
  final ValueNotifier<List<String>> selectedCategories = ValueNotifier<List<String>>([]);

  // Yuklanish holati (UI da loading ko'rsatish uchun)
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);

  CategoryController() {
    loadCategories(); // Controller yaratilganda ma'lumotni yuklash
  }

  // JSON dan yuklash mantiqi
  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString('assets/data.json');
      final List<dynamic> data = json.decode(response);

      categories.value = data.map((json) => CategoryModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Kategoriyalarni yuklashda xatolik: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getRandomWord() {
    final Random random = Random();
    final int randomIndex = random.nextInt(selectedCategories.value.length);
    CategoryModel randomCategory = categories.value.where((category) => category.id == selectedCategories.value[randomIndex]).first;
    return randomCategory.words[random.nextInt(randomCategory.words.length)];
  }

  void toggleCategory(String id, bool isLocked) {
    if (isLocked) return;

    if (selectedCategories.value.contains(id)) {
      selectedCategories.value.remove(id);
    } else {
      selectedCategories.value.add(id);
    }
    selectedCategories.value = List.from(selectedCategories.value);
  }

  bool isSelected(String id) => selectedCategories.value.contains(id);
}
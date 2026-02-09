import 'package:flutter/material.dart';
import 'package:imposter/core/config.dart';
import 'package:imposter/core/widgets/app_scaffold.dart';
import 'package:imposter/feature/data/model/category/category_model.dart';
import 'package:imposter/feature/presentation/settings/settings_screen.dart';
import 'category_controller.dart';

class CategoriesScreen extends StatelessWidget {
  // Controller bir marta yaratiladi
  final CategoryController _controller = getIt<CategoryController>();

  CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      header: _buildHeader(context),
      bottom: _buildBottomButton(),
      child: ValueListenableBuilder<bool>(
        valueListenable: _controller.isLoading,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          // 2. Kategoriyalar ro'yxatini tinglaymiz
          return ValueListenableBuilder<List<CategoryModel>>(
            valueListenable: _controller.categories,
            builder: (context, categoryList, _) {
              if (categoryList.isEmpty) {
                return const Center(
                  child: Text("Kategoriyalar mavjud emas", style: TextStyle(color: Colors.white)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: categoryList.length,
                itemBuilder: (context, index) {
                  return _buildCategoryCard(categoryList[index]);
                },
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.group, color: Colors.white, size: 30),
          ),
          const Text(
            "Kategoriyalar",
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return ValueListenableBuilder(
      valueListenable: _controller.selectedCategories,
      builder: (context, selectedIds, child) {
        print(selectedIds);
        final bool isSelected = selectedIds.contains(category.id);

        return GestureDetector(
          onTap: () => _controller.toggleCategory(category.id, category.isLocked),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF252131),
              borderRadius: BorderRadius.circular(25),
              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            category.title,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          if (category.isLocked) ...[const SizedBox(width: 8), const Icon(Icons.lock, color: Colors.white, size: 18)],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category.description,
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 80,
                  height: 80,
                  // child: Image.asset(category.imagePath, errorBuilder: (ctx, err, stack) => const Icon(Icons.fastfood, size: 60, color: Colors.white24)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return ValueListenableBuilder(
      valueListenable: _controller.selectedCategories,
      builder: (context, selectedIds, child) {
        if (selectedIds.isEmpty) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "OYNASH",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF252131)),
                ),
                Container(height: 30, width: 2, color: Colors.black12, margin: const EdgeInsets.symmetric(horizontal: 15)),
                Text(
                  "${selectedIds.length} kategoriya",
                  style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

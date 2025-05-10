import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/home_cubit/home_cubit.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key});

  static List<String> categories = ['All', 'Medical', 'Consulting', 'Coach'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    final selected = cubit.selectedCategory;

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selected;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (m) {
                cubit.changeCategory(category);
              },
            ),
          );
        },
      ),
    );
  }
}

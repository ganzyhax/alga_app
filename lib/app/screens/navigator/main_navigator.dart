import 'package:alga_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:alga_app/app/screens/navigator/components/navigator_item.dart';
import 'package:alga_app/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainNavigatorBloc, MainNavigatorState>(
      builder: (context, state) {
        if (state is MainNavigatorLoaded) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColors.background,
            body: IndexedStack(
              index: state.index, // Use IndexedStack for preserving state
              children: state.screens,
            ),
            bottomNavigationBar: Container(
              height: 80,
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: AppColors.whiteForText,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navigationItem(
                      context, 0, 'assets/icons/consultant.svg', state.index),
                  _navigationItem(
                      context, 1, 'assets/icons/comunity.svg', state.index),
                  _navigationItem(
                      context, 2, 'assets/icons/resources.svg', state.index),
                  _navigationItem(
                      context, 3, 'assets/icons/profile.svg', state.index),
                ],
              ),
            ),
          );
        }
        return Container(); // Placeholder while loading
      },
    );
  }

  Widget _navigationItem(
      BuildContext context, int index, String assetImage, int currentIndex) {
    return InkWell(
      onTap: () {
        BlocProvider.of<MainNavigatorBloc>(context)
            .add(MainNavigatorChangePage(index: index));
      },
      child: NavigationItem(
        assetImage: assetImage,
        isSelected: (currentIndex == index),
      ),
    );
  }
}

import 'package:alga_app/app/screens/driver/driver_screen.dart';
import 'package:alga_app/app/screens/passanger/passanger_screen.dart';
import 'package:bloc/bloc.dart';

import 'package:flutter/material.dart';

part 'main_navigator_event.dart';
part 'main_navigator_state.dart';

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, MainNavigatorState> {
  MainNavigatorBloc() : super(MainNavigatorInitial()) {
    List<Widget> screens = [
      PassangerScreen(),
      DriverScreen(),
    ];
    int index = 0;
    on<MainNavigatorEvent>((event, emit) async {
      if (event is MainNavigatorLoad) {
        emit(MainNavigatorLoaded(index: index, screens: screens));
      }

      if (event is MainNavigatorChangePage) {
        index = event.index;
        emit(MainNavigatorLoaded(index: index, screens: screens));
      }
      if (event is MainNavigatorClear) {
        emit(MainNavigatorInitial());
      }
    });
  }
}

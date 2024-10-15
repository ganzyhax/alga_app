import 'package:alga_app/app/screens/driver/bloc/driver_bloc.dart';
import 'package:alga_app/app/screens/navigator/bloc/main_navigator_bloc.dart';
import 'package:alga_app/app/screens/navigator/main_navigator.dart';
import 'package:alga_app/app/screens/passanger/bloc/passanger_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AlgaApp extends StatelessWidget {
  const AlgaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // final dashboardBloc = GetIt.instance<DashboardBloc>();
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => MainNavigatorBloc()..add(MainNavigatorLoad()),
          ),
          // Provide DriverBloc here
          BlocProvider(create: (context) => DriverBloc()),
          BlocProvider(create: (context) => PassengerBloc()),
        ],
        child: MaterialApp(
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaleFactor: 1.0,
              ),
              child: child!,
            );
          },
          debugShowCheckedModeBanner: false,
          title: 'WeGlobal',
          home: CustomNavigationBar(),
        ));
  }
}